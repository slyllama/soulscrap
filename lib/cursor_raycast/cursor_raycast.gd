class_name CursorRaycast extends Node3D
# CursorRaycast
# Does what it says on the tin - casts a ray from the mouse cursor into the 3D world.

@export var active = false
@onready var cursor_position = Utils.NULL_VEC3

func _process(_delta: float) -> void:
	if !active:
		cursor_position = Utils.NULL_VEC3
		return
	var mouse_pos = get_viewport().get_mouse_position()
	#var from = Global.camera.project_ray_origin(mouse_pos)
	var from = global_position
	var to = from + Global.camera.project_ray_normal(mouse_pos) * 200.0 + Vector3(0, 1.5, 0)
	var space_state = get_world_3d().direct_space_state
	
	var mesh_query = PhysicsRayQueryParameters3D.create(from, to)
	mesh_query.collide_with_bodies = true
	
	var intersect = space_state.intersect_ray(mesh_query)
	if intersect: cursor_position = intersect.position
	else: cursor_position = Utils.NULL_VEC3
