extends Node

const TICK_SIZE = 100 # tick duration in milliseconds

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
