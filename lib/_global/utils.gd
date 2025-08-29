extends Node

const TICK_SIZE = 100 # tick duration in milliseconds
const NULL_VEC3 = Vector3(-999, -999, -999)
const PCOLOR_DEBUG = "fA684d"

signal tick
var tick_running = false
var _delta = 0.0

func clerp(speed: float) -> float: # critical lerp (doesn't rubber-band at low frame rates)
	return(clamp(1.0 - exp(-speed * _delta), 0.0, 1.0))

func get_all_children(in_node, arr := []):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return(arr)

func pdebug(text: String, module = "", color = "white") -> void:
	if module != "": module = "[color=darkgray][" + module.capitalize() + "][/color] "
	print_rich(module + "[color=" + color + "]" + text + "[/color]")

var _d = 0.0

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	tick_running = true

func _process(delta: float) -> void:
	if !tick_running: return
	_delta = delta
	_d += delta
	if _d >= TICK_SIZE * 0.001:
		_d = 0
		tick.emit()
