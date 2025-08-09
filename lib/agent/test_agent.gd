class_name Agent extends CharacterBody3D

const TARGET_THRESHOLD = 0.5

@export var agent_name = "((Test Agent))"
@export var resilience = 100
@export var speed = 1.0
@export var acceleration = 10.0

@export var stationary = false
@export var target: Node3D
@export var manual_target_position = Vector3.ZERO

func get_bone_position(skeleton: Skeleton3D, bone_name: String) -> Vector3:
	var _bone_idx = skeleton.find_bone(bone_name)
	var _bone_origin = skeleton.get_bone_global_pose(_bone_idx).origin
	return(skeleton.to_global(_bone_origin))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_home"):
		if !target: target = Global.player
		else:
			target = null
			manual_target_position = Vector3.ZERO

func _ready() -> void:
	$AnguishedClaw/AnimationPlayer.speed_scale = randf_range(0.9, 1.1)
	$AnguishedClaw/AnimationPlayer.seek(randf_range(0.0, 0.75))
	$AnguishedClaw/AnimationPlayer.play("idle")
	$NodeSpatial.text = agent_name

func _physics_process(delta: float) -> void:
	if !stationary:
		# $NavTarget is always the target for the navigation system
		if target: $NavTarget.global_position = target.global_position
		else: $NavTarget.global_position = manual_target_position
	else: $NavTarget.global_position = self.global_position
	
	
	$NodeSpatial.global_position = get_bone_position(
		$AnguishedClaw/Skeleton3D, "Hand") + Vector3(0, 0.35, 0)
	
	var _dir = Vector3.ZERO
	$NavAgent.target_position = $NavTarget.global_position
	if global_position.distance_to($NavTarget.global_position) > TARGET_THRESHOLD:
		_dir = $NavAgent.get_next_path_position() - global_position
		_dir = _dir.normalized()
	
	velocity = lerp(velocity, _dir * speed, Utils.clerp(acceleration))
	move_and_slide()
	
	if !global_position.is_equal_approx($NavAgent.get_next_path_position()):
		$AnimTarget.look_at($NavAgent.get_next_path_position())
	$AnimTarget.rotation_degrees.x = 0.0
	$AnguishedClaw.rotation.y = lerp_angle(
		$AnguishedClaw.rotation.y, $AnimTarget.rotation.y - 0.01, Utils.clerp(10.0))
	
	$Decal.rotation_degrees.y += delta * 10.0
	$OutlineDecal.rotation_degrees.y -= delta * 10.0
	if $YCast.is_colliding():
		$BoundingCircle.global_position.y = lerp(
			$BoundingCircle.global_position.y, $YCast.get_collision_point().y, Utils.clerp(10.0))
