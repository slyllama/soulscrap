class_name DissolveControl extends Control

var DissolveShader = load("res://generic/materials/shaders/dissolve.gdshader")
const PaintMask = preload("res://generic/materials/textures/paint_mask.jpg")

@onready var mat = ShaderMaterial.new()

@export var include_children = true
@export_range(0.0, 1.0) var dissolve_scale = 1.0:
	get: return(dissolve_scale)
	set(_val):
		dissolve_scale = _val
		if material:
			_set_dissolve(_val)

func _set_dissolve(_val) -> void:
	if material:
		material.set_shader_parameter("dissolve_state", _val)

func _get_dissolve() -> float:
	if material: return(material.get_shader_parameter("dissolve_state"))
	else: return(-1.0)

func disappear(duration = 0.21) -> void:
	var _i = _get_dissolve() # initial dissolve value
	var _t = create_tween()
	_t.tween_method(_set_dissolve, 0.0, 1.0, duration)

func appear(duration = 0.21) -> void:
	var _i = _get_dissolve() # initial dissolve value
	var _t = create_tween()
	_t.tween_method(_set_dissolve, _get_dissolve(), 0.0, duration)

func _ready():
	mat.shader = DissolveShader
	material = mat
	
	mat.resource_local_to_scene = true
	mat.shader.resource_local_to_scene = true
	
	if include_children:
		for _n in get_children():
			if _n is Control:
				_n.material = mat
	
	material.set_shader_parameter("dissolve_texture", PaintMask)
	_set_dissolve(1.0)
