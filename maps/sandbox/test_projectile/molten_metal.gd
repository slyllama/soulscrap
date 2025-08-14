extends Node3D

var _target_speed = 0.3

func _set_fire_spiral_exponent(_val) -> void:
	$Pivot/FireSpiral.get_node("fire_spiral").get_active_material(0).set_shader_parameter("exponent", _val)

func _ready() -> void:
	await get_tree().process_frame
	$Pivot.top_level = true
	$Pivot.global_position = global_position
	$Pivot.global_rotation.y = get_parent().global_rotation.y
	
	_set_fire_spiral_exponent(1.0)
	var _t = create_tween()
	_t.tween_method(_set_fire_spiral_exponent, 1.0, 0.0, 0.1)
	var _u = create_tween()
	_u.tween_method(_set_fire_spiral_exponent, 0.0, 1.0, 0.4)

func _physics_process(_delta: float) -> void:
	_target_speed = lerp(_target_speed, 0.05, Utils.clerp(5.0))
	position += Vector3.FORWARD.rotated(
		Vector3.UP, get_parent().global_rotation.y) * _target_speed

func _on_lifetime_timeout() -> void:
	queue_free()
