extends HBoxContainer

var card_source = null

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		if Global.dragging_card:
			if !get_window().gui_get_hovered_control() is CardIcon:
				reset_card_source()
				Global.clear_dragged_card()

func reset_card_source() -> void:
	if card_source is CardIcon:
		card_source.update(Global.dragging_card)

func _ready() -> void:
	Global.card_drag_started.connect(func(_card_source):
		card_source = _card_source
		if card_source is CardIcon:
			card_source.update("blank"))
	
	Global.card_drag_ended.connect(func(_card_destination_id):
		if _card_destination_id:
			card_source.update(_card_destination_id)
		else: card_source = null)
	
	get_window().focus_exited.connect(func():
		if Global.dragging_card:
			reset_card_source()
			Global.clear_dragged_card())

func _on_mouse_entered() -> void: Global.mouse_in_ui = true
func _on_mouse_exited() -> void: Global.mouse_in_ui = false
