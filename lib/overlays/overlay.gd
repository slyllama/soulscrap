extends CanvasLayer

func set_highlight_value(_val) -> void:
	$Highlight.material.set_shader_parameter("value", _val)

func set_smoke_value(_val) -> void:
	$Smoke.material.set_shader_parameter("value", _val)

func _on_start_timer_timeout() -> void:
	var _t = create_tween()
	_t.tween_method(set_smoke_value, 0.0, 1.0, 0.6)
	_t.tween_callback(func(): layer = -1)

func _ready() -> void:
	PlayerData.projectile_fired.connect(func():
		var _t = create_tween()
		_t.tween_method(set_highlight_value, 0.0, 1.0, 0.3))
	
	Global.sprint_started.connect(func(): $Anime.appear(0.2))
	Global.sprint_ended.connect(func(): $Anime.disappear(0.4))
