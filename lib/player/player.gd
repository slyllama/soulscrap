extends CharacterBody3D

@export var speed = 1.9
@export var zoom_increment = 0.25
@export var zoom_minimum = 1.0
@export var zoom_maximum = 3.0

@onready var _target_zoom = position.z

func _input(_event: InputEvent) -> void:
	# Handle zoom
	if Input.is_action_just_pressed("zoom_in"):
		_target_zoom -= zoom_increment
	elif Input.is_action_just_pressed("zoom_out"):
		_target_zoom += zoom_increment

func _physics_process(_delta: float) -> void:
	var _direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"): _direction.z = 1.0
	if Input.is_action_pressed("move_back"): _direction.z = -1.0
	if Input.is_action_pressed("strafe_left"): _direction.x = -1.0
	if Input.is_action_pressed("strafe_right"): _direction.x = 1.0
	
	_direction = _direction.normalized()
	velocity = $Orbit.basis * Vector3.FORWARD * _direction.z
	velocity += $Orbit.basis * Vector3.RIGHT * _direction.x
	velocity *= speed
	
	var _y_diff = $YCast.global_position.y - $YCast.get_collision_point().y
	velocity.y += clamp(Global.GRAVITY * _y_diff, Global.GRAVITY, 0.0)
	
	move_and_slide()
	
	# Handle zoom
	_target_zoom = clamp(_target_zoom, zoom_minimum, zoom_maximum)
	$Orbit/SpringAxis.spring_length = lerp($Orbit/SpringAxis.spring_length,
		_target_zoom, Utils.clerp(24.0))
	$Orbit/Camera.position.z = lerp($Orbit/Camera.position.z,
		$Orbit/SpringAxis/Spring.position.z, Utils.clerp(20.0))
