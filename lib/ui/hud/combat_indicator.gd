extends TextureRect

func _set_dissolve(_val) -> void:
	material.set_shader_parameter("dissolve_state", _val)

func _ready() -> void:
	Global.mouse_capture_lost.connect(func():
		visible = true
		$Motes.emitting = true
		var _t = create_tween()
		_t.tween_method(_set_dissolve, 1.0, 0.0, 0.21))
	
	Global.mouse_capture_gained.connect(func():
		$Motes.emitting = false
		var _t = create_tween()
		_t.tween_method(_set_dissolve, 0.0, 1.0, 0.1)
		_t.tween_callback(func(): visible = false))
	
	get_window().size_changed.connect(func():
		$Motes.global_position.x = get_window().size.x / 2.0)
	
	# Initialise
	$Motes.emitting = false
	$Motes.global_position.x = get_window().size.x / 2.0
