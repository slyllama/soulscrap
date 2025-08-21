@icon("res://generic/editor_icons/Map.svg")
extends Node3D

const AnguishedClaw = preload("res://maps/sandbox/agents/anguished_claw/anguished_claw.tscn")

func set_bus_vol(_vol: float) -> void:
	AudioServer.set_bus_volume_linear(0, _vol)

func _init() -> void:
	set_bus_vol(0.0)

func _spawn_ac() -> void:
	await get_tree().create_timer(1.0).timeout
	var _ac = AnguishedClaw.instantiate()
	_ac.position.z = 0.01
	_ac.tree_exiting.connect(_spawn_ac) # spawn another
	add_child(_ac)
	$HUD/AgentEditor.target_agent = _ac

func _ready() -> void:
	SettingsHandler.open()
	
	_spawn_ac()
	
	var _v = create_tween()
	_v.tween_method(set_bus_vol, 0.0, 1.0, 3.0)
