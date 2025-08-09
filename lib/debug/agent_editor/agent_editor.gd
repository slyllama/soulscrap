@tool
extends "res://lib/ui/container/container.gd"
# AgentEditor
# Tools for testing out agents in realtime

@export var target_agent: Agent

func _ready() -> void:
	if !target_agent: return
	$VBox/AgentDetails.text = str(target_agent)

func _on_toggle_player_targeting_button_down() -> void:
	if !target_agent.target:
		target_agent.target = Global.player
		$VBox/TogglePlayerTargeting.text = "Untarget Player"
	else:
		target_agent.target = null
		target_agent.manual_target_position = Vector3.ZERO
		$VBox/TogglePlayerTargeting.text = "Target Player"

func _on_stationary_button_down() -> void:
	if !target_agent.stationary:
		$VBox/Stationary.text = "Make Moving"
		target_agent.stationary = true
	else:
		$VBox/Stationary.text = "Make Stationary"
		target_agent.stationary = false
