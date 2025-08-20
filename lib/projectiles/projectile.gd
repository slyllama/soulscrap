@icon("res://generic/editor_icons/Projectile.svg")
class_name Projectile extends Node3D

signal cast_finished

## If static, the projectile source will be planted at the agent's position
## when casted, and remain there
@export var static_position: bool = true
## The time taken between [code]cast()[/code] and [code]fire()[/code].
@export var cast_time: float = 1.0
## Damage dealt to the player.
@export var damage: int = 10

@onready var _cast_timer = Timer.new()

## "Wind up" the projectile. The [code]super()[/code] for this function should
## always be called after any custom statements.
func cast() -> void:
	_cast_timer.start()

## "Fire" the projectile. The [code]super()[/code] for this function should
## always be called after any custom statements.
func fire() -> void:
	await get_tree().process_frame
	queue_free()

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
