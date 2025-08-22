@icon("res://generic/editor_icons/Card.svg")
class_name CardIcon extends Panel
# CardIcon
# These cards display Components - weapons, items, resources, etc

const DRAG_THRESHOLD = 5.0

@export var id = "blank"
@export_range(1, 16) var quantity = 1
@export var enabled = true

var _last_mouse_pos = Vector2.ZERO
var _mouse_delta = 0.0 # distance (length)
var _mouse_in = false
var _mouse_down = false
var _updated = true # wait a single frame after updating to prevent any instant input actions
var _cd = 0.0
var _strayed_in = false

func update(new_id = id) -> void:
	_updated = false
	
	id = new_id
	_cd = Components.get_cooldown(id)
	
	# Hide the icon if the card is blank
	if id == "blank": $Mask.visible = false
	else: $Mask.visible = true
	$Mask/Icon.texture = Components.get_texture(id)
	if quantity > 1 and id != "blank":
		$Qty.text = str(quantity)
		$Qty.visible = true
	else: $Qty.visible = false
	
	if enabled: mouse_filter = Control.MOUSE_FILTER_PASS
	else: mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	await get_tree().process_frame
	_updated = true

#region Helper functions
func _is_on_cd() -> bool: # are we on cooldown?
	return !$CDTimer.is_stopped()

func _gain_focus() -> void:
	if enabled:
		z_index = 2
		$Hover.visible = true

func _lose_focus() -> void:
	if enabled: z_index = 0 # only alter z-index when enabled
	$Hover.visible = false
	_unhover()

func _hover() -> void: $Mask.modulate = Color(0.5, 0.5, 0.5)
func _unhover() -> void: $Mask.modulate = Color(1.0, 1.0, 1.0)
#endregion

func use() -> void:
	if id == "blank": return # has no use
	_unhover()
	
	if _cd > 0.0 and _is_on_cd(): return
	var _t = create_tween()
	_t.tween_method($Use._set_dissolve, 0.0, 1.0, 0.32)
	_t.set_trans(Tween.TRANS_SINE)
	_t.set_ease(Tween.EASE_OUT)
	
	if _cd > 0.0:
		$Mask/CDText.visible = true
		$CDTimer.wait_time = _cd
		$CDTimer.start()
	
	PlayerData.component_used.emit(id)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		_strayed_in = false
		if Global.dragging_card and _mouse_in:
			# DRAG ENDED
			var _old_id = id
			var _old_qty = quantity
			quantity = Global.dragging_card_qty
			update(Global.dragging_card)
			Global.card_drag_ended.emit(_old_id, _old_qty)
			Global.dragging_card = null
			Global.dragging_card_qty = 1

func _ready() -> void:
	get_window().focus_exited.connect(_lose_focus)
	update()
	
	# Prevent dropping on the card when it is in cooldown. The mouse filter is
	# set to PASS where possible so that the user can hover over it
	Global.card_drag_started.connect(func(_i):
		if !$CDTimer.is_stopped():
			mouse_filter = Control.MOUSE_FILTER_IGNORE)
	Global.card_drag_ended.connect(func(_i, _j):
		if enabled: mouse_filter = Control.MOUSE_FILTER_PASS)

func _process(_delta: float) -> void:
	if !$CDTimer.is_stopped() and _cd > 0.0:
		var _tl = $CDTimer.time_left
		var _ratio = _tl / _cd
		_ratio = 1.0 - cos((_ratio * PI) / 2.0)
		$Mask/CDBar.size.y = 50.0 * _ratio
		
		if _tl > 1.9: $Mask/CDText.text = str(snapped(_tl, 1))
		else: $Mask/CDText.text = str(snapped(_tl, 0.1))
	
	# Only check for dragging if the cooldown timer is stopped
	if Input.is_action_pressed("left_click") and $CDTimer.is_stopped():
		_mouse_delta = (Vector2(get_global_mouse_position()
			- _last_mouse_pos).length())
	else: _mouse_delta = 0.0
	
	if id != "blank" and !Global.dragging_card and !_strayed_in:
		if _mouse_in and _mouse_delta > 5.0:
			# DRAG STARTED
			Global.dragging_card = id
			Global.dragging_card_qty = quantity
			Global.card_drag_started.emit(self)

func _on_mouse_entered() -> void:
	if Input.is_action_pressed("left_click"):
		_strayed_in = true
	if enabled and id != "blank":
		Global.card_hovered.emit(id)
	_mouse_in = true
	_gain_focus()

func _on_mouse_exited() -> void:
	if enabled and id != "blank":
		Global.card_unhovered.emit()
	_mouse_in = false
	_lose_focus()

func _on_gui_input(_event: InputEvent) -> void:
	if !enabled or !_updated: return
	
	if Input.is_action_just_pressed("left_click"):
		_mouse_down = true
		_last_mouse_pos = get_global_mouse_position()
		_hover()
	elif Input.is_action_just_released("left_click"):
		_mouse_down = false
		_unhover()
		
		if !Global.dragging_card:
			if _mouse_delta < DRAG_THRESHOLD: use()

func _on_cd_timer_timeout() -> void:
	if enabled:
		mouse_filter = Control.MOUSE_FILTER_PASS
	$Mask/CDText.visible = false
