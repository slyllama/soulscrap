extends Area3D

@export var component_id := "blank"

var in_range = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if in_range:
			Global.start_cast.emit(5.0)

func _ready() -> void:
	$NodeSpatial.text = Components.get_title(component_id)
	$NodeSpatial.update_appearance()
	
	Global.cast_stopped.connect(func(_success):
		if _success: queue_free())

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		in_range = true

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		in_range = false
