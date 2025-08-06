extends Panel

func randomize_color() -> void:
	var _c = randi_range(0, Utils.WEB_COLORS.size() - 1)
	$Mask/Icon.modulate = Color(Utils.WEB_COLORS[_c])

func _gain_focus() -> void:
	z_index = 99
	$Hover.visible = true

func _lose_focus() -> void:
	z_index = 0
	$Hover.visible = false
	$Mask.modulate = Color(1.0, 1.0, 1.0)

func use() -> void:
	var _t = create_tween()
	_t.tween_method($Use._set_dissolve, 0.0, 1.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _ready() -> void:
	get_window().focus_exited.connect(_lose_focus)
	randomize_color() # TODO: only for placeholders

func _on_mouse_entered() -> void: _gain_focus()
func _on_mouse_exited() -> void: _lose_focus()

func _on_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click"):
		$Mask.modulate = Color(0.5, 0.5, 0.5)
	elif Input.is_action_just_released("left_click"):
		$Mask.modulate = Color(1.0, 1.0, 1.0)
		
		use()
