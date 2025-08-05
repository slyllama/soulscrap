@tool
extends Panel

@export var title = "((Window))":
	get: return(title)
	set(_val):
		title = _val
		$VBox/Header/Title.text = title

func close() -> void:
	var _t = create_tween()
	_t.tween_method(_set_dissolve, 0.0, 1.0, 0.1)
	_t.tween_callback(queue_free)

func _set_dissolve(_val) -> void:
	material.set_shader_parameter("dissolve_state", _val)

func _on_mouse_entered() -> void:
	if !Engine.is_editor_hint():
		Global.mouse_in_ui = true

func _on_mouse_exited() -> void:
	if !Engine.is_editor_hint():
		Global.mouse_in_ui = false

func _on_close_button_down() -> void:
	close()
