class_name Player extends CharacterBody3D

const _NodeSpatial = preload("res://lib/ui/node_spatial/node_spatial.tscn")
const P_STRAFE = "parameters/strafe/add_amount"
const P_FORWARD = "parameters/forward/add_amount"

@onready var skeleton = get_node("PlayerMesh/BotArmature/Skeleton3D")

@export var speed = 1.9
@export var nitro_speed = 3.8
@export var acceleration = 9.0
@export var gravity_damping = 10.0

@export var nitro_impulse_time = 0.35
@export var nitro_impulse_multiplier = 7.0
@export var nitro_tempo_cost = 15

var target_speed = speed
var _actual_speed = target_speed
var _target_velocity = 0.0
var _target_nitro_trail_width = 0.0

var nitro_active = false

## Get the position in world space of the specified bone.
func get_bone_position(bone_name: String) -> Vector3:
	var _bone_idx = skeleton.find_bone(bone_name)
	var _bone_origin = skeleton.get_bone_global_pose(_bone_idx).origin
	return(skeleton.to_global(_bone_origin))

func _emit_evaded() -> void:
	var _d = _NodeSpatial.instantiate()
	_d.text = str("Evaded")
	_d.font_size = 24
	_d.text_color = Color.GOLD
	Global.player.add_child(_d)
	_d.position.y += 1.0
	_d.float_away()

func _ready() -> void:
	Global.player = self
	
	PlayerData.evaded.connect(_emit_evaded)
	
	SettingsHandler.propogated.connect(func(_param):
		if _param == "dof":
			var _val = SettingsHandler.settings.dof
			var _v = false
			if _val == "true": _v = true
			$Orbit/Track/Camera.attributes.dof_blur_far_enabled = _v)
	
	Utils.tick.connect(func():
		if Input.is_action_pressed("nitro"):
			if PlayerData.change_tempo(-3):
				if !nitro_active:
					_target_nitro_trail_width = 0.1
					$PlayerMesh/Trail3D_Nitro.reenable()
				nitro_active = true
				PlayerData.sprint_started.emit()
			else:
				nitro_active = false
				PlayerData.sprint_ended.emit()
		else:
			nitro_active = false
			PlayerData.sprint_ended.emit()
			PlayerData.change_tempo(1))
	
	get_window().focus_exited.connect(func():
		velocity = Vector3.ZERO)

func _process(_delta: float) -> void:
	$Engine.pitch_scale = 1.0 + clamp(_target_velocity.length() * 0.2, 0.0, 0.85)
	_target_nitro_trail_width = lerp(
		_target_nitro_trail_width, 0.0, Utils.clerp(5.0))
	$PlayerMesh/Trail3D_Nitro.trail_width = _target_nitro_trail_width

var _c = nitro_impulse_time
var _e = 0.0
const MAGIC = 1.70158;
const MAGIC_ADD = MAGIC + 1.0;

func _physics_process(delta: float) -> void:
	# Nitro (sprinting) - handles FOV changes too
	if nitro_active:
		if PlayerData.tempo > 0:
			$Orbit._target_fov = $Orbit.fov + 5.0
			target_speed = nitro_speed
	else:
		$Orbit._target_fov = $Orbit.fov
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
	
	# Apply a "dodge" impulse if nitro is initiated while moving
	if _dir.length() > 0:
		if Input.is_action_just_pressed("nitro"):
			if PlayerData.change_tempo(-nitro_tempo_cost):
				$Engine/Dodge.play()
				PlayerData.in_dodge = true
				_c = 0.0
	if _c < nitro_impulse_time:
		_e = 0.0
		_c += delta / nitro_impulse_time
		var _d = (1.0 + MAGIC_ADD * pow(_c - 1.0, 3)
			+ MAGIC * pow(_c - 1.0, 2.0));
		_d = sin(PI * _c) * nitro_impulse_multiplier
		_target_velocity *= clamp(_d + 1.0, 1.0, INF)
	elif _e < 0.5: # TODO: additional dodge time
		_e += delta
	else:
		if PlayerData.in_dodge:
			PlayerData.in_dodge = false
	
	velocity = lerp(
		velocity, _target_velocity, Utils.clerp(acceleration))
	
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
		$PlayerMesh.rotation.y = lerp_angle(
			$PlayerMesh.rotation.y, $Orbit.rotation.y, Utils.clerp(7.0))
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	# Orient the combat handler
	if $CombatPivot.cursor_position > Utils.NULL_VEC3:
		$CombatPivot.look_at($CombatPivot.cursor_position)
	else:
		$CombatPivot.rotation.y = $Orbit.rotation.y
		$CombatPivot.rotation.z = -PI / 2.0
	$CombatPivot.rotation.x = clamp($CombatPivot.rotation.x, 0.0, INF)
	$CombatPivot.position.x = 0.0
	$CombatPivot.position.z = 0.0
	
	# Interpolate attached weapon to make it smoother
	$WeaponMount.global_position = get_bone_position("HeadCap")
	$WeaponMount.rotation.y = lerp_angle(
		$WeaponMount.rotation.y, $PlayerMesh.rotation.y, Utils.clerp(12.0))
	$WeaponMount/MoltenCannon.rotation.y = lerp_angle(
		$WeaponMount/MoltenCannon.rotation.y,
		$CombatPivot.rotation.y - $PlayerMesh.rotation.y, Utils.clerp(12.0))
	
	# Handle animations
	var _calc_forward = lerp(
		$PlayerMesh/Tree.get(P_FORWARD), _dir.z * 1.15, Utils.clerp(12.0))
	$PlayerMesh/Tree.set(P_FORWARD, _calc_forward)
	var _calc_strafe = lerp(
		$PlayerMesh/Tree.get(P_STRAFE), _dir.x * 1.5, Utils.clerp(12.0))
	$PlayerMesh/Tree.set(P_STRAFE, _calc_strafe)
