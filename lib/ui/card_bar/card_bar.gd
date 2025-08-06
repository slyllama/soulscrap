extends HBoxContainer

func _on_mouse_entered() -> void: Global.mouse_in_ui = true
func _on_mouse_exited() -> void: Global.mouse_in_ui = false
