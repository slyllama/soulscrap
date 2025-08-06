extends Node

const TICK_SIZE = 100 # tick duration in milliseconds
const WEB_COLORS = ["#ffffff", "#c0c0c0", "#ff0000", "#ffff00", "#808000", "#800000", "#00ff00", "#008000", "#00ffff", "#008080", "#0000ff", "#000080", "#ff00ff", "#800080"]

signal tick
var _delta = 0.0

func clerp(speed: float) -> float: # critical lerp (doesn't rubber-band at low frame rates
	return(clamp(1.0 - exp(-speed * _delta), 0.0, 1.0))

var _d = 0.0

func _process(delta: float) -> void:
	_delta = delta
	_d += delta
	if _d >= TICK_SIZE * 0.001:
		_d = 0
		tick.emit()
