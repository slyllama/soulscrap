@icon("res://generic/editor_icons/Projectile.svg")
class_name Projectile extends Node3D

signal cast_finished

var active = false

## If static, the projectile source will be planted at the agent's position
## when casted, and remain there
@export var static_position: bool = true
## The time taken between [code]cast()[/code] and [code]fire()[/code].
@export var cast_time: float = 1.0
## Projectile ID as listed in Component library.
@export var id: String
## Will only deal damage to the player if this is set.
@export var damages_player = false
## Will only deal damage to enemies if this is set.
@export var damages_enemy = true
## Damage will be dealt if valid agents (either the player or enemies as set by
## [code]damages_player[/code] and [code]damages_enemy[/code] enter this shape.
## This shape must be named "Hitbox" and be on layer 3.
@export var collision_area: Area3D
## Disable projectile damage and conditions if it comes into contact with a
## player or enemy agent, depending on [code]damages_player[/code] and
## [code]damages_enemy[/code].
@export var destroy_on_hit = true

@onready var _cast_timer = Timer.new()

## "Wind up" the projectile. The [code]super()[/code] for this function should
## always be called after any custom statements.
func cast() -> void:
	_cast_timer.start()

func destroy() -> void:
	await get_tree().process_frame
	queue_free()

## "Fire" the projectile. The [code]super()[/code] for this function should
## always be called after any custom statements.
func fire() -> void:
	_cast_timer.stop()
	active = true
	for _i in 5: await get_tree().process_frame
	
	# Check players - single check on fire
	if damages_player:
		var _bodies = collision_area.get_overlapping_bodies()
		for _b in _bodies:
			if _b is Player:
				if active:
					PlayerData.add_condition("poisoned") # TODO: conditions testing
					PlayerData.take_damage(Components.get_damage(id))
				if destroy_on_hit:
					active = false
				
	# Check enemies - single check on fire
	if damages_enemy:
		var _areas = collision_area.get_overlapping_areas()
		for _a in _areas:
			if _a.name == "Hitbox":
				if _a.get_parent() is Agent:
					if active:
						_a.get_parent().lose_integrity(Components.get_damage(id))
					if destroy_on_hit:
						active = false
		PlayerData.projectile_fired.emit()

func _ready() -> void:
	add_child(_cast_timer)
	_cast_timer.one_shot = true
	_cast_timer.wait_time = cast_time
	_cast_timer.timeout.connect(func():
		cast_finished.emit()
		fire())
	if get_node_or_null("Floor"): # remove debugging floor
		get_node("Floor").queue_free()
	await get_tree().process_frame
	if static_position:
		top_level = true
