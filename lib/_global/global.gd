extends Node

const GRAVITY = -9.8

# Global references
var camera: Camera3D

# States
var mouse_in_ui = false

func _ready() -> void:
	if DisplayServer.screen_get_size().x > 2000:
		if !Engine.is_embedded_in_editor():
			get_window().size *= 2.0
		get_window().content_scale_factor = 2.0
		
		if OS.get_name() != "macos":
			DisplayServer.cursor_set_custom_image(
				load("res://generic/textures/cursor_2x.png"))
	
	if !Engine.is_embedded_in_editor():
		get_window().position = DisplayServer.screen_get_position() + Vector2i(32, 64)
