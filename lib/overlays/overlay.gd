extends CanvasLayer

func set_smoke_value(_val) -> void:
	$Smoke.material.set_shader_parameter("value", _val)

func _on_start_timer_timeout() -> void:
	var _t = create_tween()
	_t.tween_method(set_smoke_value, 0.0, 1.0, 0.6)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_home"):
		$DamageTaken.disappear(0.35)
