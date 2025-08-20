@tool
extends "res://lib/ui/container/container.gd"
# AgentEditor
# Tools for testing out agents in realtime

@export var target_agent: Agent

func update_stats() -> void:
	$VBox/IntegrityStat.description = (
		"Integrity: " + (str(target_agent.current_integrity)
			+ "/" + str(target_agent.integrity)))

func _ready() -> void:
	if !target_agent or Engine.is_editor_hint(): return
	$VBox/Header/Title.text = str(target_agent.agent_name)
	target_agent.integrity_changed.connect(update_stats)
	
	await get_tree().process_frame
	update_stats()

func _on_stationary_button_down() -> void:
	if !target_agent: return
	if !target_agent.stationary:
		$VBox/Stationary.text = "Make Moving"
		target_agent.stationary = true
	else:
		$VBox/Stationary.text = "Make Stationary"
		target_agent.stationary = false

func _on_reset_integrity_button_down() -> void:
	if !target_agent: return
	target_agent.reset_integrity()
