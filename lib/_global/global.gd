@icon("res://generic/editor_icons/CoreHandler.svg")
extends Node

const GRAVITY = -9.8

# Bus signals
signal card_drag_started(card_source)
signal card_drag_ended(dest_id: String, dest_qty: int)
signal card_hovered(id)
signal card_unhovered
signal mouse_capture_lost
signal mouse_capture_gained

signal start_cast(time: float)
signal cast_stopped(successful: bool)

# Global references
var camera: Camera3D
var player: CharacterBody3D

# States
var mouse_in_ui = false
var dragging_card = null # should be the ID of the card being dragged when active
var dragging_card_qty = 1

func clear_dragged_card() -> void:
	card_drag_ended.emit(null, 1)
	dragging_card = null

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_end"):
		if !get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
		else: get_tree().paused = false

func _ready() -> void:
	Utils.pdebug("*** This is DWELT. ***", "Global")
	if DisplayServer.screen_get_size().x > 2000:
		if !Engine.is_embedded_in_editor():
			get_window().size *= 2.0
		get_window().content_scale_factor = 1.75
		
		if OS.get_name() != "macos":
			DisplayServer.cursor_set_custom_image(
				load("res://generic/textures/cursor_2x.png"))
	
	if !Engine.is_embedded_in_editor():
		get_window().position = DisplayServer.screen_get_position() + Vector2i(32, 64)
