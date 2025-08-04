extends CanvasLayer

func _ready() -> void:
	Utils.tick.connect(func():
		await get_tree().process_frame
		$Tempo.value = PlayerData.tempo)
