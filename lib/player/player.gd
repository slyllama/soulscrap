extends CharacterBody3D

@export var speed = 1.9
@export var nitro_speed = 7.0
@export var acceleration = 9.0
@export var gravity_damping = 10.0

var target_speed = speed
var _actual_speed = target_speed
var _target_velocity = 0.0

var nitro_active = false

func _ready() -> void:
	Utils.tick.connect(func():
		if nitro_active: PlayerData.change_tempo(-3)
		else: PlayerData.change_tempo(1))
	
	get_window().focus_exited.connect(func():
		velocity = Vector3.ZERO)

func _physics_process(_delta: float) -> void:
	# Nitro (sprinting) - handles FOV changes too
	if Input.is_action_pressed("nitro"):
		nitro_active = true
		if PlayerData.tempo > 0:
			$Orbit._target_fov = $Orbit.fov + 5.0
			target_speed = nitro_speed
		else:
			$Orbit._target_fov = $Orbit.fov
			target_speed = speed
	else:
		$Orbit._target_fov = $Orbit.fov
		nitro_active = false
		target_speed = speed
	_actual_speed = lerp(_actual_speed, target_speed, Utils.clerp(10.0))
	
	var _direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		_direction.z = 1.0
	if Input.is_action_pressed("move_back"):
		_direction.z = -1.0
	if Input.is_action_pressed("strafe_left"): _direction.x = -1.0
	if Input.is_action_pressed("strafe_right"): _direction.x = 1.0
	
	_direction = _direction.normalized()
	_target_velocity = $Orbit.basis * Vector3.FORWARD * _direction.z * Vector3(1, 0, 1)
	_target_velocity += $Orbit.basis * Vector3.RIGHT * _direction.x * Vector3(1, 0, 1)
	_target_velocity *= _actual_speed
	velocity = lerp(velocity, _target_velocity, Utils.clerp(acceleration))
	
	# Apply gravity and hover
	var _y_diff = $YCast.global_position.y - $YCast.get_collision_point().y
	var _y_target = abs($YCast.target_position.y)
	velocity.y += Global.GRAVITY / gravity_damping
	if _y_diff < _y_target: velocity.y += _y_target - _y_diff
	
	move_and_slide()
	
	# Handle player mesh operations (facing rotation)
	if _direction.length() > 0:
		$PlayerMesh/Stars.amount_ratio = 1.0
	else: $PlayerMesh/Stars.amount_ratio = 0.2
	
	if velocity.length() > 0.1:
		$PlayerMesh.rotation_degrees.y = lerp(
			$PlayerMesh.rotation_degrees.y, $Orbit.rotation_degrees.y, Utils.clerp(7.0))
	
	# Handle animations
	var _calc_forward = lerp(
		$PlayerMesh/Tree.get("parameters/forward/add_amount"),
		_direction.z, Utils.clerp(5.0))
	$PlayerMesh/Tree.set("parameters/forward/add_amount", _calc_forward)
	var _calc_strafe = lerp(
		$PlayerMesh/Tree.get("parameters/strafe/add_amount"),
		_direction.x * 2.0, Utils.clerp(5.0))
	$PlayerMesh/Tree.set("parameters/strafe/add_amount", _calc_strafe)
	
	print(velocity.y)
