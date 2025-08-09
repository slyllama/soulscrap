@tool
extends MeshInstance3D

@export var radius = 0.5:
	get: return(radius)
	set(_val):
		radius = _val
		mesh.top_radius = radius
		mesh.bottom_radius = radius
@export var albedo_color = Color.WHITE:
	get: return(albedo_color)
	set(_val):
		albedo_color = _val
		mesh.surface_get_material(0).set_shader_parameter("albedo_color", albedo_color)
