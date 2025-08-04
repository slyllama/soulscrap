extends CharacterBody3D

@export var speed = 1.9
@export var acceleration = 9.0
var _target_velocity = 0.0

func _physics_process(_delta: float) -> void:
	var _direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"): _direction.z = 1.0
	if Input.is_action_pressed("move_back"): _direction.z = -1.0
	if Input.is_action_pressed("strafe_left"): _direction.x = -1.0
	if Input.is_action_pressed("strafe_right"): _direction.x = 1.0
	
	_direction = _direction.normalized()
	_target_velocity = $Orbit.basis * Vector3.FORWARD * _direction.z
	_target_velocity += $Orbit.basis * Vector3.RIGHT * _direction.x
	_target_velocity *= speed
	velocity = lerp(velocity, _target_velocity, Utils.clerp(acceleration))
	
	var _y_diff = $YCast.global_position.y - $YCast.get_collision_point().y
	velocity.y += clamp(Global.GRAVITY * _y_diff, Global.GRAVITY, 0.0)
	
	move_and_slide()
	
	# Handle player mesh operations (facing rotation)
	if velocity.length() > 0.1:
		$PlayerMesh.rotation_degrees.y = lerp(
			$PlayerMesh.rotation_degrees.y, $Orbit.rotation_degrees.y, Utils.clerp(20.0))
	$PlayerMesh.rotation_degrees.z = lerp(
		$PlayerMesh.rotation_degrees.z, velocity.x * -9.0, Utils.clerp(20.0))
