extends CanvasLayer

func _ready() -> void:
	$Overlay.visible = true

func _process(_delta: float) -> void:
	$Tempo.value = lerp(
		float($Tempo.value), float(clamp(PlayerData.tempo, 0, 100)), Utils.clerp(30.0))
