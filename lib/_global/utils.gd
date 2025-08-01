extends Node

var _delta = 0.0

func clerp(speed: float) -> float: # critical lerp (doesn't rubber-band at low frame rates
	return(clamp(1.0 - exp(-speed * _delta), 0.0, 1.0))

func _process(delta: float) -> void:
	_delta = delta
