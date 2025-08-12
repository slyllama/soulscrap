@tool
extends Panel

signal dissolved # hidden
signal undissolved 

@export var title = "((Window))":
	get: return(title)
	set(_val):
		title = _val
		$VBox/Header/Title.text = title

func close() -> void:
	var _t = create_tween()
	_t.tween_method(_set_dissolve, 0.0, 1.0, 0.1)
	_t.tween_callback(queue_free)

func undissolve() -> void:
	var _t = create_tween()
	_t.tween_method(_set_dissolve, 1.0, 0.0, 0.1)

func dissolve() -> void: # hides the container without freeing it
	var _t = create_tween()
	_t.tween_method(_set_dissolve, material.get_shader_parameter("dissolve_state"), 1.0, 0.1)

func shrink() -> void: # should be called with any update function
	size.y = 0

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
