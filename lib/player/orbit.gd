extends Node3D

@export var zoom_increment = 0.2
@export var zoom_minimum = 0.8
@export var zoom_maximum = 1.5
@export var orbit_sensitivity = 0.5
@export var orbit_smoothing = 20.0
@export var camera_smoothing = 10.0
@export var fov = 80.0

@onready var _last_mouse_delta = _mouse_delta
@onready var _target_pivot_x = rotation_degrees.x
@onready var _target_pivot_y = rotation_degrees.y
@onready var _target_zoom = zoom_minimum
@onready var _target_fov = fov
@onready var _v_offset = $Track/Camera.v_offset

var _mouse_delta = Vector2.ZERO

func _is_mouse_captured() -> bool:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: return(true)
	else: return(false)

func shake_camera(v_offset: float = 0.12, z_rotation: float = 1.0) -> void:
	var _v1 = create_tween()
	_v1.tween_property(
		$Track/Camera, "v_offset", _v_offset - v_offset, 0.03)
	_v1.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	var _r1 = create_tween()
	_r1.tween_property(
		$Track/Camera, "rotation_degrees:z", z_rotation, 0.03)
	_r1.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	_r1.set_parallel()
	
	await _v1.finished
	_v1.stop()
	_r1.stop()
	
	_v1 = create_tween()
	_v1.tween_property(
		$Track/Camera, "v_offset", _v_offset, 0.25)
	_v1.set_trans(Tween.TRANS_BOUNCE)
	_r1 = create_tween()
	_r1.tween_property(
		$Track/Camera, "rotation_degrees:z", 0.0, 0.25)
	_r1.set_trans(Tween.TRANS_BOUNCE)
	_r1.set_parallel()

func _input(event: InputEvent) -> void:
	# Handle orbiting
	if event is InputEventMouseMotion and _is_mouse_captured():
		_mouse_delta = event.relative
	
	if Input.is_action_just_pressed("ui_cancel"):
		if _is_mouse_captured():
			Global.mouse_capture_lost.emit()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Global.mouse_capture_gained.emit()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("left_click"):
		if !_is_mouse_captured() and !get_window().gui_get_hovered_control() is Control:
			Global.mouse_capture_gained.emit()
			await get_tree().process_frame # don't fire weapon on first frame of capture
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Handle zoom inputs
	if Input.is_action_just_pressed("zoom_in"): _target_zoom -= zoom_increment
	elif Input.is_action_just_pressed("zoom_out"): _target_zoom += zoom_increment

func _ready() -> void:
	Global.camera = $Track/Camera
	Global.mouse_capture_gained.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	PlayerData.projectile_fired.connect(shake_camera)
	PlayerData.damage_taken.connect(func(_amount): shake_camera(0.4, 2.0))
	
	get_window().focus_exited.connect(func():
		Global.mouse_capture_lost.emit()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE)

func _process(_delta: float) -> void:
	if _mouse_delta == _last_mouse_delta: _mouse_delta = Vector2.ZERO
	
	# Handle orbit transforms
	_target_pivot_y -= _mouse_delta.x * orbit_sensitivity
	rotation_degrees.y = lerp(
		rotation_degrees.y, _target_pivot_y, Utils.clerp(orbit_smoothing))
	_target_pivot_x -= _mouse_delta.y * orbit_sensitivity
	_target_pivot_x = clamp(_target_pivot_x, -80.0, 20.0)
	rotation_degrees.x = lerp(
		rotation_degrees.x, _target_pivot_x, Utils.clerp(orbit_smoothing))
	
	# Handle zoom
	_target_zoom = clamp(_target_zoom, zoom_minimum, zoom_maximum)
	$Track/SpringAxis.spring_length = lerp($Track/SpringAxis.spring_length,
		_target_zoom, Utils.clerp(24.0))
	$Track/Camera.position.z = lerp($Track/Camera.position.z,
		$Track/SpringAxis/Spring.position.z, Utils.clerp(camera_smoothing))
	
	# Smooth camera motion (and FOV)
	$Track.global_rotation = global_rotation
	$Track.global_position = lerp(
		$Track.global_position, global_position + Vector3(0, 0.2, 0), Utils.clerp(camera_smoothing))
	$Track/Camera.fov = lerp($Track/Camera.fov, _target_fov, Utils.clerp(7.0))
	
	_last_mouse_delta = _mouse_delta
