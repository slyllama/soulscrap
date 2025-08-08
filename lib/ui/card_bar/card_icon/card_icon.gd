extends Panel
# CardIcon
# These cards display Components - weapons, items, resources, etc

const DRAG_THRESHOLD = 5.0

@export var id = "blank"
@export var enabled = true

var _last_mouse_pos = Vector2.ZERO
var _mouse_delta = 0.0 # distance (length)
var _mouse_in = false
var _mouse_down = false

func update(new_id = id) -> void:
	id = new_id
	
	# Hide the icon if the card is blank
	if id == "blank": $Mask.visible = false
	else: $Mask.visible = true
	
	if enabled: mouse_filter = Control.MOUSE_FILTER_PASS
	else: mouse_filter = Control.MOUSE_FILTER_IGNORE

func randomize_color() -> void:
	var _c = randi_range(0, Utils.WEB_COLORS.size() - 1)
	$Mask/Icon.modulate = Color(Utils.WEB_COLORS[_c])

func _gain_focus() -> void:
	if enabled:
		z_index = 2
		$Hover.visible = true

func _lose_focus() -> void:
	z_index = 0
	$Hover.visible = false
	_unhover()

func _hover() -> void: $Mask.modulate = Color(0.5, 0.5, 0.5)
func _unhover() -> void: $Mask.modulate = Color(1.0, 1.0, 1.0)

func use() -> void:
	if id == "blank": return # has no use
	
	PlayerData.damage_taken.emit()
	var _t = create_tween()
	_t.tween_method($Use._set_dissolve, 0.0, 1.0, 0.6)
	_t.set_trans(Tween.TRANS_SINE)
	_t.set_ease(Tween.EASE_OUT)
	_unhover()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		if Global.dragging_card and _mouse_in:
			update(Global.dragging_card)
			Global.dragging_card = null
			Global.card_drag_ended.emit()

func _ready() -> void:
	get_window().focus_exited.connect(_lose_focus)
	randomize_color() # TODO: only for placeholders
	update()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("left_click"):
		_mouse_delta = (Vector2(get_global_mouse_position()
			- _last_mouse_pos).length())
	else: _mouse_delta = 0.0
	
	if !Global.dragging_card:
		if _mouse_in and _mouse_delta > 5.0:
			Global.dragging_card = id
			Global.card_drag_started.emit()

func _on_mouse_entered() -> void:
	_mouse_in = true
	_gain_focus()

func _on_mouse_exited() -> void:
	_mouse_in = false
	_lose_focus()

func _on_gui_input(_event: InputEvent) -> void:
	if !enabled: return
	
	if Input.is_action_just_pressed("left_click"):
		_mouse_down = true
		_last_mouse_pos = get_global_mouse_position()
		_hover()
	elif Input.is_action_just_released("left_click"):
		_mouse_down = false
		_unhover()
		
		if !Global.dragging_card:
			if _mouse_delta < DRAG_THRESHOLD: use()
