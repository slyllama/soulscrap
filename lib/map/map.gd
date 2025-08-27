@icon("res://generic/editor_icons/Map.svg")
extends Node3D

func set_bus_vol(_vol: float) -> void:
	AudioServer.set_bus_volume_linear(0, _vol)

func _init() -> void:
	set_bus_vol(0.0)

func _ready() -> void:
	SettingsHandler.open()
	var _v = create_tween()
	_v.tween_method(set_bus_vol, 0.0, 1.0, 3.0)
