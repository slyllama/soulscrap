extends HBoxContainer

var card_source = null
var _clicks = 1

func _input(_event: InputEvent) -> void:
	if !Global.dragging_card:
	# Handle special keyboard inputs for primary and secondary cards
		if Input.is_action_just_pressed("card_primary"): $CardPrimary._hover()
		elif Input.is_action_just_released("card_primary"): $CardPrimary.use()
		if Input.is_action_just_pressed("card_secondary"): $CardSecondary._hover()
		elif Input.is_action_just_released("card_secondary"): $CardSecondary.use()
		
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if Input.is_action_just_pressed("left_click"):
				if _clicks > 0: $CardPrimary.use()
				else: _clicks += 1
		
	if Input.is_action_just_released("left_click"):
		if Global.dragging_card:
			if !get_window().gui_get_hovered_control() is CardIcon:
				reset_card_source()
				Global.clear_dragged_card()

func get_deck() -> Array: # returns dictionary of quantities by ID
	var _a = []
	for _n in get_children():
		if _n is CardIcon:
			_a.append({ "id": _n.id, "qty": _n.quantity })
	return(_a)

func reset_card_source() -> void:
	if card_source is CardIcon:
		card_source.quantity = Global.dragging_card_qty
		card_source.update(Global.dragging_card)

func _ready() -> void:
	Global.card_drag_started.connect(func(_card_source):
		card_source = _card_source
		if card_source is CardIcon:
			card_source.update("blank"))
	
	Global.card_drag_ended.connect(func(_dest_id, _dest_qty):
		if _dest_id and _dest_qty:
			if card_source.id != Global.dragging_card:
				card_source.quantity = _dest_qty
				card_source.update(_dest_id)
				PlayerData.current_deck = get_deck()
				PlayerData.deck_changed.emit()
		else: card_source = null)
	
	get_window().focus_exited.connect(func():
		_clicks = 0
		if Global.dragging_card:
			reset_card_source()
			Global.clear_dragged_card())
	
	await get_tree().process_frame
	PlayerData.current_deck = get_deck()
	PlayerData.deck_changed.emit()

func _on_mouse_entered() -> void: Global.mouse_in_ui = true
func _on_mouse_exited() -> void: Global.mouse_in_ui = false
