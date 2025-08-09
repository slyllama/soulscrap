@tool
extends MeshInstance3D

@export var radius = 0.5:
	get: return(radius)
	set(_val):
		radius = _val
		mesh.top_radius = radius
		mesh.bottom_radius = radius
