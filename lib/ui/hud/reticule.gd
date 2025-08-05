extends TextureRect

func _ready() -> void:
	Global.mouse_capture_gained.connect(func():
		var _t = create_tween()
		_t.tween_property(self, "modulate:a", 1.0, 0.1))
	
	Global.mouse_capture_lost.connect(func():
		var _t = create_tween()
		_t.tween_property(self, "modulate:a", 0.0, 0.1))
