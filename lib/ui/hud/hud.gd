extends CanvasLayer

const DEBUG_MSEC = 0.25 # debug only updates on this period
const SettingsPane = preload("res://lib/ui/settings_pane/settings_pane.tscn")

func _ready() -> void:
	$Overlay.visible = true
	# Disable all inputs for the fake card
	for _n in Utils.get_all_children($CursorCard):
		if _n is Control: _n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	Global.card_drag_started.connect(func(_card_source):
		$CursorCard.quantity = Global.dragging_card_qty
		$CursorCard.update(Global.dragging_card)
		$CursorCard.visible = true)
	
	Global.card_drag_ended.connect(func(_dest_id, _dest_qty):
		$CursorCard.update("blank")
		$CursorCard.visible = false)

var _d = 0.0

func _process(delta: float) -> void:
	$CursorCard.global_position = (get_window().get_mouse_position()
		- $CursorCard.size * 0.5)
	
	# Debug
	if _d < DEBUG_MSEC:
		_d += delta
		return
	else: _d = 0.0
	$PrimsCounter.text = (str(snapped(Performance.get_monitor(
		Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME), 1)))
	$PrimsCounter.text += ("/" + str(snapped(Performance.get_monitor(
		Performance.RENDER_VIDEO_MEM_USED) / 1048576, 1)) + "MB")
	$AggroDebug.text = "Aggro state: " + str(PlayerData.aggro_agent_count)

func _on_settings_button_down() -> void:
	var _c = SettingsPane.instantiate()
	add_child(_c)
