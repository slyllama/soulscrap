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
	
	#PlayerData.aggro_gained.connect(func():
		#var _t2 = create_tween()
		#_t2.tween_property($Track1, "volume_linear", 0.75, 0.95)
		#var _t3 = create_tween()
		#_t3.set_parallel()
		#_t3.tween_property($Track2, "volume_linear", 0.75, 0.45))
	
	#PlayerData.aggro_lost.connect(func():
		#var _t2 = create_tween()
		#_t2.tween_property($Track1, "volume_linear", 0.0, 0.95)
		#var _t3 = create_tween()
		#_t3.set_parallel()
		#_t3.tween_property($Track2, "volume_linear", 0.0, 0.45))
	
	var _v = create_tween()
	_v.tween_method(set_bus_vol, 0.0, 1.0, 3.0)

func _on_anguished_claw_target_reached() -> void:
	$AnguishedClaw.target = null
	await get_tree().process_frame # gets a frame to reset target, in case the target is the same
	var _t = randi_range(0, $ClawCandidates.get_child_count() - 1)
	$AnguishedClaw.target = $ClawCandidates.get_child(_t)

func _on_anguished_claw_2_target_reached() -> void:
	$AnguishedClaw2.target = null
	await get_tree().process_frame # gets a frame to reset target, in case the target is the same
	var _t = randi_range(0, $ClawCandidates.get_child_count() - 1)
	$AnguishedClaw2.target = $ClawCandidates.get_child(_t)
