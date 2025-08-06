@tool
extends TextureRect

@export var flipped = false:
	get: return(flipped)
	set(_val):
		flipped = _val
		if flipped:
			flip_h = true
			$Mask.flip_h = true

@export var variable = ""

@export var bar_modulation = Color.WHITE:
	get: return(bar_modulation)
	set(_val):
		bar_modulation = _val
		$Mask/Progress.self_modulate = bar_modulation

var _valid = false

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if variable:
		if PlayerData.get(variable):
			_valid = true

func _process(_delta: float) -> void:
	if !_valid: return
	var _c = clamp(float(PlayerData.get(variable)), 0, 100)
	$Mask/Progress.value = lerp(
		$Mask/Progress.value, float(_c), Utils.clerp(15.0))
