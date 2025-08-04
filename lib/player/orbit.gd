extends Node3D

@export var zoom_increment = 0.2
@export var zoom_minimum = 0.9
@export var zoom_maximum = 2.2
@export var orbit_sensitivity = 0.5
@export var orbit_smoothing = 20.0
@export var camera_smoothing = 10.0

@onready var _last_mouse_delta = _mouse_delta
@onready var _target_pivot_x = rotation_degrees.x
@onready var _target_pivot_y = rotation_degrees.y
@onready var _target_zoom = zoom_minimum

var _mouse_delta = Vector2.ZERO

func _input(event: InputEvent) -> void:
	# Handle orbiting
	if (event is InputEventMouseMotion
		and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		_mouse_delta = event.relative
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("left_click"):
		if !Global.mouse_in_ui:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Handle zoom inputs
	if Input.is_action_just_pressed("zoom_in"): _target_zoom -= zoom_increment
	elif Input.is_action_just_pressed("zoom_out"): _target_zoom += zoom_increment

func _ready() -> void:
	Global.camera = $Track/Camera
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
	
	# Smooth camera motion
	$Track.global_rotation = global_rotation
	$Track.global_position = lerp(
		$Track.global_position, global_position, Utils.clerp(camera_smoothing))
	
	_last_mouse_delta = _mouse_delta
