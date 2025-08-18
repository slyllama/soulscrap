@icon("res://generic/editor_icons/Agent.svg")
class_name Agent extends CharacterBody3D

const TARGET_THRESHOLD = 0.5
const NodeSpatial = preload("res://lib/ui/node_spatial/node_spatial.tscn")

signal integrity_changed

@export var agent_name = "((Test Agent))"

@export_category("Parameters")
@export var integrity = 100
@export var speed = 1.0
@export var acceleration = 10.0

@export_category("AI")
@export var stationary = false
@export var target_player_on_aggro = true
@export var aggro_radius = 1.0:
	get: return(aggro_radius)
	set(_val):
		aggro_radius = _val
		$AggroArea/Collision.shape.radius = aggro_radius
@export var target: Node3D
@export var manual_target_position = Vector3.ZERO

@export_category("Art")
@export var model: Node3D

@onready var current_integrity = integrity
var target_bar_value = 100.0

func get_bone_position(skeleton: Skeleton3D, bone_name: String) -> Vector3:
	var _bone_idx = skeleton.find_bone(bone_name)
	var _bone_origin = skeleton.get_bone_global_pose(_bone_idx).origin
	return(skeleton.to_global(_bone_origin))

func lose_integrity(amount: int) -> void:
	target = Global.player
	
	if current_integrity - amount >= 0:
		var _d = NodeSpatial.instantiate()
		_d.text = str(amount)
		_d.font_size = 24
		
		# Add amall amount of variation
		var _offset = randf_range(-0.25, 0.25)
		_d.position.x += _offset
		_d.position.y += _offset
		
		add_child(_d)
		_d.float_away()
		
		model.get_node("AnimationPlayer").play("take_damage")
		current_integrity -= amount
		integrity_changed.emit()

func reset_integrity() -> void:
	current_integrity = integrity
	integrity_changed.emit()

func _ready() -> void:
	if model:
		# Set up animation logic
		var _anim: AnimationPlayer = model.get_node("AnimationPlayer")
		_anim.speed_scale = randf_range(0.9, 1.1)
		_anim.set_blend_time("take_damage", "idle", 0.2)
		_anim.seek(randf_range(0.0, 0.75))
		_anim.animation_finished.connect(func(_anim_name):
			if _anim_name == "take_damage":
				_anim.play("idle"))
		
		_anim.play("idle")
		
	$NodeSpatial.text = agent_name

func _process(_delta: float) -> void:
	var _ir = float(current_integrity) / float(integrity) # integrity ratio
	target_bar_value = lerp(
		target_bar_value, _ir * 100.0, Utils.clerp(20.0))
	$NodeSpatial.update_value(target_bar_value)

func _physics_process(delta: float) -> void:
	if !stationary:
		# $NavTarget is always the target for the navigation system
		if target: $NavTarget.global_position = target.global_position
		else: $NavTarget.global_position = manual_target_position
	else: $NavTarget.global_position = self.global_position
	
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
			$BoundingCircle.global_position.y, 
			$YCast.get_collision_point().y, Utils.clerp(10.0))

func _on_aggro_area_body_entered(body: Node3D) -> void:
	if body is Player and target_player_on_aggro:
		target = Global.player

func _on_aggro_area_body_exited(body: Node3D) -> void:
	if body is Player:
		target = null
