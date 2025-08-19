@icon("res://generic/editor_icons/Agent.svg")
class_name Agent extends CharacterBody3D
## A general class for handling enemy and NPC movement, pathing, combat,
## and interactions.
##
## The Agent class provides a framework and a number of generic classes and
## parameters for giving a Dwelt creature life and personality! It's meant to
## be supplemented with an extension scene for each creature which includes its
## own art, animations, effects, and so on.

## The agent is counted as having reached the navigation target if the distance
## between that target and itself is less than the [param TARGET_THRESHOLD].
const TARGET_THRESHOLD = 0.5
const _NodeSpatial = preload("res://lib/ui/node_spatial/node_spatial.tscn")

## Emitted when the [param current_integrity] of the agent has changed e.g.,
## through taking damage.
signal integrity_changed
## Emitted when the player enters the aggro range of the agent.
signal aggro_range_entered

## The name of the agent, which will appear above them it mob titles are
## enabled.
@export var agent_name = "((Test Agent))"

@export_category("Parameters")
## The integrity is the base health of the agent. [param current_integrity]
## is measured against this value.
@export var integrity: int = 100
## The movement rate of the agent.
@export var speed: float = 1.0
## The "smoothness" of the agent's movement. A higher value introduces more
## tightness and friction.
@export var acceleration: float = 10.0

@export_category("AI")
## Forces the agent to be immobile, even if [param target_player_on_aggro] is
## [param true].
@export var stationary: bool = false
## If [param true], the agent will move toward the player once the player
## enters its aggro range (determined by [param aggro_radius]).
@export var target_player_on_aggro: bool = true
## If the player gets closer to the agent than this radius, aggro will be
## activated.
@export var aggro_radius: float = 1.0:
	get: return(aggro_radius)
	set(_val):
		aggro_radius = _val
		$AggroArea/Collision.shape.radius = aggro_radius
## If this is not null, the agent's navigation target will be this node.
@export var target: Node3D
## If the [param manual_target_position] is null, the agent's navigation
## target will be this point.
@export var manual_target_position: Vector3 = Vector3.ZERO

@export_category("Art")
## The agent's model. It requires certain animations to be named properly, like
## "idle" and "take_damage".
@export var model: Node3D
## If true, the agent will continue to look at its target even after it has
## reached it.
@export var force_look_at_target = false

## The current "health" of the agent, compared against its maximum health
## expressed in [param integrity].
@onready var current_integrity = integrity
var _target_bar_value = 100.0

func get_distance_to_player() -> float:
	return(global_position.distance_to(Global.player.global_position))

## Get the position in world space of the specified bone.
func get_bone_position(skeleton: Skeleton3D, bone_name: String) -> Vector3:
	var _bone_idx = skeleton.find_bone(bone_name)
	var _bone_origin = skeleton.get_bone_global_pose(_bone_idx).origin
	return(skeleton.to_global(_bone_origin))

## Mainly for taking damage. The amount is displayed as a small floating number.
func lose_integrity(amount: int) -> void:
	target = Global.player
	
	if current_integrity - amount > 0:
		var _d = _NodeSpatial.instantiate()
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
	else:
		queue_free() # TODO: die

## Restore the agent to full health.
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
	_target_bar_value = lerp(
		_target_bar_value, _ir * 100.0, Utils.clerp(20.0))
	$NodeSpatial.update_value(_target_bar_value)

func _physics_process(delta: float) -> void:
	# $NavTarget is always the target for the navigation system
	if target: $NavTarget.global_position = target.global_position
	else: $NavTarget.global_position = manual_target_position
	
	var _dir = Vector3.ZERO
	$NavAgent.target_position = $NavTarget.global_position
	if global_position.distance_to($NavTarget.global_position) > TARGET_THRESHOLD:
		_dir = $NavAgent.get_next_path_position() - global_position
		_dir = _dir.normalized()
	
	velocity = lerp(velocity, _dir * speed, Utils.clerp(acceleration))
	if !stationary:
		move_and_slide()
	
	if (!global_position.is_equal_approx($NavAgent.get_next_path_position())
		or force_look_at_target):
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
		aggro_range_entered.emit()
		PlayerData.aggro_gained.emit()
		target = Global.player

func _on_aggro_area_body_exited(body: Node3D) -> void:
	if body is Player:
		PlayerData.aggro_lost.emit()
		target = null
