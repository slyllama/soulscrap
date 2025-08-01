@tool
extends RichTextLabel

var _d = 0.0

func get_fps_as_text() -> String:
	var _fps = Engine.get_frames_per_second()
	var _color = "green"
	
	if _fps < 30: _color = "yellow"
	elif _fps < 10: _color = "red"
	return("[color=" + _color + "]" + str(snapped(_fps, 1)) + "fps[/color]")

func _process(delta: float) -> void:
	_d += delta
	if _d > 0.1:
		_d = 0
		text = get_fps_as_text()
