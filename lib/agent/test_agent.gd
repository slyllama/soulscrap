extends CharacterBody3D

@export var nav_target: Node3D

func _physics_process(delta: float) -> void:
	if !nav_target: return # no navigation target
	var _dir = Vector3.ZERO
	$NavAgent.target_position = nav_target.global_position
	_dir = $NavAgent.get_next_path_position() - global_position
	_dir = _dir.normalized()
	
	velocity = lerp(velocity, _dir, delta * 10.0)
	move_and_slide()
