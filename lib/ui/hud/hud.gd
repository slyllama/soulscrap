extends CanvasLayer

func _ready() -> void:
	$Overlay.visible = true
	
	# Disable all inputs for the fake card
	for _n in Utils.get_all_children($CursorCard):
		if _n is Control: _n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	Global.card_drag_started.connect(func(_card_source):
		$CursorCard.update(Global.dragging_card)
		$CursorCard.visible = true)
	
	Global.card_drag_ended.connect(func(_card_destination_id):
		$CursorCard.update("blank")
		$CursorCard.visible = false)

func _process(_delta: float) -> void:
	$PrimsCounter.text = (str(snapped(Performance.get_monitor(
		Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME), 1)))
	$PrimsCounter.text += ("/" + str(snapped(Performance.get_monitor(
		Performance.RENDER_VIDEO_MEM_USED) / 1048576, 1)) + "MB")
	$TempoCounter.text = "Tempo: " + str(PlayerData.tempo)
	$CursorCard.global_position = (get_window().get_mouse_position()
		- $CursorCard.size * 0.5)
