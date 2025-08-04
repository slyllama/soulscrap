class_name Trail3D extends MeshInstance3D

@export var trail_width = 0.006

@export var start_alpha = 1.0
@export var end_alpha = 0.0
@export var diffuse_color = Color(1.0, 1.0, 1.0)

var start_color
var end_color

var enabled = true
var running = false
var og_pos
var points = []
var life_points = []

func _basis(): return(get_global_transform().basis)
func _origin(): return(get_global_transform().origin)

func _append_point():
	points.append(_origin())
	life_points.append(0.0)

func _remove_point(p):
	points.remove_at(p)
	life_points.remove_at(p)

func _ready():
	mesh = ImmediateMesh.new()
	og_pos = _origin()
	
	start_color = Color(diffuse_color, start_alpha)
	end_color = Color(diffuse_color, end_alpha)

func reenable():
	enabled = true
	points = []
	life_points = []

func _process(delta):
	if (og_pos - _origin()).length() > 0.1 and enabled:
		_append_point()
		og_pos = _origin()
	
	var p = 0;
	var max_points = points.size()
	while p < max_points:
		life_points[p] += delta
		if life_points[p] > 1.0:
			_remove_point(p)
			p -= 1
			if p < 0: p = 0
		max_points = points.size()
		p += 1
	
	mesh.clear_surfaces()
	
	# Rendering
	if points.size() < 2: return
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(points.size()):
		var t = float(i) / (points.size() - 1.0)
		if start_color and end_color:
			var current_color = start_color.lerp(end_color, 1.0 - t)
			mesh.surface_set_color(current_color)
		var t0 = float(i) / points.size()
		var t1 = t
		mesh.surface_set_uv(Vector2(t0, 0))
		mesh.surface_add_vertex(to_local(points[i] + Vector3(trail_width, 0.0, 0.0)))
		mesh.surface_set_uv(Vector2(t1, 1))
		mesh.surface_add_vertex(to_local(points[i] - Vector3(trail_width, 0.0, 0.0)))
	mesh.surface_end()
