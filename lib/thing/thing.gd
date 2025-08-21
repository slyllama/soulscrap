extends Area3D

var in_range = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if in_range:
			Global.start_cast.emit(1.2)

func _ready() -> void:
	Global.cast_stopped.connect(func(_success):
		if _success: queue_free())

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		in_range = true

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		in_range = false
