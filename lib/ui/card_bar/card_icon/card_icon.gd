class_name CardIcon extends Panel
# CardIcon
# These cards display Components - weapons, items, resources, etc

const DRAG_THRESHOLD = 5.0

@export var id = "blank"
@export var enabled = true

var _last_mouse_pos = Vector2.ZERO
var _mouse_delta = 0.0 # distance (length)
var _mouse_in = false
var _mouse_down = false
var _updated = true # wait a single frame after updating to prevent any instant input actions

func update(new_id = id) -> void:
	_updated = false
	id = new_id
	
	# Hide the icon if the card is blank
	if id == "blank": $Mask.visible = false
	else: $Mask.visible = true
	$Mask/Icon.texture = Components.get_texture(id)
	
	if enabled: mouse_filter = Control.MOUSE_FILTER_PASS
	else: mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	await get_tree().process_frame
	_updated = true

#region Helper functions
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
	
	var _t = create_tween()
	_t.tween_method($Use._set_dissolve, 0.0, 1.0, 0.32)
	_t.set_trans(Tween.TRANS_SINE)
	_t.set_ease(Tween.EASE_OUT)
	_unhover()
	
	if id in Components.component_library:
		if PlayerData.change_tempo(Components.component_library[id].tempo_cost * -1):
			pass
		else: return
	
	Global.component_used.emit(id)
	PlayerData.damage_taken.emit()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		if Global.dragging_card and _mouse_in:
			var _old_id = id
			
			update(Global.dragging_card)
			Global.card_drag_ended.emit(_old_id)
			Global.dragging_card = null

func _ready() -> void:
	get_window().focus_exited.connect(_lose_focus)
	update()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("left_click"):
		_mouse_delta = (Vector2(get_global_mouse_position()
			- _last_mouse_pos).length())
	else: _mouse_delta = 0.0
	
	if id != "blank" and !Global.dragging_card:
		if _mouse_in and _mouse_delta > 5.0:
			Global.dragging_card = id
			# Emit self as a source so that CardBar can clear it (or reset it
			# if window changes focus, etc)
			Global.card_drag_started.emit(self)

func _on_mouse_entered() -> void:
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
