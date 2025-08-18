extends Node3D

var _target_speed = 0.8
@onready var spiral_mesh: MeshInstance3D = get_node("Pivot/FireSpiral/fire_spiral")
@onready var spiral_mesh_2: MeshInstance3D = get_node("Pivot/FireSpiral2/fire_spiral")
@onready var metal_mesh: MeshInstance3D = get_node("Mesh/Sphere")
@onready var position_delta = get_parent().global_transform.basis.z * _target_speed

func _duplicate_mat(mesh: MeshInstance3D) -> void:
	var _mat = mesh.get_active_material(0).duplicate(true)
	mesh.set_surface_override_material(0, _mat)

func _set_fire_spiral_exponent(_val) -> void:
	spiral_mesh.get_active_material(0).set_shader_parameter("exponent", _val)
	spiral_mesh_2.get_active_material(0).set_shader_parameter("exponent", _val)

func fire() -> void:
	$Pivot.global_position = global_position
	$Sound.pitch_scale = randf_range(0.8, 1.2)
	$Sound.play()
	$Lifetime.start()
	
	_set_fire_spiral_exponent(1.0)
	var _t = create_tween()
	_t.tween_method(_set_fire_spiral_exponent, 1.0, 0.0, 0.1)
	var _u = create_tween()
	_u.tween_method(_set_fire_spiral_exponent, 0.0, 1.0, 0.4)

func _ready() -> void:
	visible = false
	top_level = true
	
	_duplicate_mat(spiral_mesh)
	_duplicate_mat(spiral_mesh_2)
	_duplicate_mat(metal_mesh)
	
	await get_tree().process_frame
	$Pivot.top_level = true
	$Pivot.global_rotation = get_parent().global_rotation
	$Pivot.global_rotation.x = clamp($Pivot.global_rotation.x, 0.0, INF)

func _physics_process(_delta: float) -> void:
	var _time_ratio = $Lifetime.time_left / $Lifetime.wait_time
	var _adj_ratio = pow((1.0 - _time_ratio), 1.5)
	_target_speed = lerp(_target_speed, 0.25, Utils.clerp(10.0))
	$Mesh/Trail.trail_width = 0.05 * _time_ratio
	if _time_ratio > 0.0:
		metal_mesh.get_active_material(0).set_shader_parameter("dissolve_state", _adj_ratio)
	
	if position_delta: position -= position_delta

func _on_lifetime_timeout() -> void:
	queue_free()
