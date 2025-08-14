extends CharacterBody3D

const P_STRAFE = "parameters/strafe/add_amount"
const P_FORWARD = "parameters/forward/add_amount"

@export var speed = 1.9
@export var nitro_speed = 7.0
@export var acceleration = 9.0
@export var gravity_damping = 10.0

var target_speed = speed
var _actual_speed = target_speed
var _target_velocity = 0.0

var nitro_active = false

func _ready() -> void:
	Global.player = self
	
	Utils.tick.connect(func():
		if nitro_active: PlayerData.change_tempo(-3)
		else: PlayerData.change_tempo(1))
	
	# Aim visibility
	Global.mouse_capture_gained.connect(func():
		$CombatPivot/CombatHandler/Aim.visible = true)
	Global.mouse_capture_lost.connect(func():
		$CombatPivot/CombatHandler/Aim.visible = false)
	
	get_window().focus_exited.connect(func():
		$CombatPivot/CombatHandler/Aim.visible = false
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
	
	var _dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"): _dir.z = 1.0
	if Input.is_action_pressed("move_back"): _dir.z = -1.0
	if Input.is_action_pressed("strafe_left"): _dir.x = -1.0
	if Input.is_action_pressed("strafe_right"): _dir.x = 1.0
	
	_dir = _dir.normalized()
	_target_velocity = $Orbit.basis * Vector3.FORWARD * _dir.z * Vector3(1, 0, 1)
	_target_velocity += $Orbit.basis * Vector3.RIGHT * _dir.x * Vector3(1, 0, 1)
	_target_velocity *= _actual_speed
	velocity = lerp(velocity, _target_velocity, Utils.clerp(acceleration))
	
	# Apply gravity and hover
	var _y_diff = $YCast.global_position.y - $YCast.get_collision_point().y
	var _y_target = abs($YCast.target_position.y)
	if !$YCast.is_colliding(): # apply gravity even if beyond raycast height
		_y_diff = _y_target
	velocity.y += Global.GRAVITY / gravity_damping
	if _y_diff < _y_target: velocity.y += _y_target - _y_diff
	
	move_and_slide()
	
	# Handle player mesh operations (facing rotation)
	if _dir.length() > 0:
		$PlayerMesh/Stars.amount_ratio = 1.0
	else: $PlayerMesh/Stars.amount_ratio = 0.2
	if velocity.length() > 0.1:
		$Orbit/Track/Camera.rotation_degrees.z = lerp( # extremely gentle camera rotation
			$Orbit/Track/Camera.rotation_degrees.z, 0.65 * -_dir.x, Utils.clerp(2.0))
		$PlayerMesh.rotation_degrees.y = lerp(
			$PlayerMesh.rotation_degrees.y, $Orbit.rotation_degrees.y, Utils.clerp(7.0))
	
	# Orient the combat handler
	if $CombatPivot.cursor_position > Utils.NULL_VEC3:
		$CombatPivot.look_at($CombatPivot.cursor_position + Vector3(0, 0.25, 0))
	else: $CombatPivot.rotation.y = $Orbit.rotation.y
	$CombatPivot.position.x = 0.0
	$CombatPivot.position.z = 0.0
	
	# Handle animations
	var _calc_forward = lerp(
		$PlayerMesh/Tree.get(P_FORWARD), _dir.z, Utils.clerp(5.0))
	$PlayerMesh/Tree.set(P_FORWARD, _calc_forward)
	var _calc_strafe = lerp(
		$PlayerMesh/Tree.get(P_STRAFE), _dir.x * 1.2, Utils.clerp(5.0))
	$PlayerMesh/Tree.set(P_STRAFE, _calc_strafe)
