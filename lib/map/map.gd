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
	
	$Layer1.volume_linear = 0.5
	PlayerData.aggro_gained.connect(func():
		var _t = create_tween()
		_t.tween_property($Layer2, "volume_linear", 0.5, 1.5))
	PlayerData.aggro_lost.connect(func():
		var _t = create_tween()
		_t.tween_property($Layer2, "volume_linear", 0.0, 1.5))
	
	_spawn_ac()
	
	#$Ambience.play()
	$Layer1.play()
	$Layer2.play()
	var _v = create_tween()
	_v.tween_method(set_bus_vol, 0.0, 1.0, 3.0)
