extends Node

const TICK_SIZE = 100 # tick duration in milliseconds

signal tick
var _delta = 0.0

func clerp(speed: float) -> float: # critical lerp (doesn't rubber-band at low frame rates
	return(clamp(1.0 - exp(-speed * _delta), 0.0, 1.0))

func get_all_children(in_node, arr := []):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return(arr)

var _d = 0.0

func _process(delta: float) -> void:
	_delta = delta
	_d += delta
	if _d >= TICK_SIZE * 0.001:
		_d = 0
		tick.emit()
