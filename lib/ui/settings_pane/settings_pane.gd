@tool
extends "res://lib/ui/container/container.gd"

func _ready() -> void:
	if Engine.is_editor_hint(): return
	get_tree().paused = true
	undissolve()

func _on_tree_exiting() -> void:
	get_tree().paused = false
