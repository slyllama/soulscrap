extends Agent

func attack() -> void:
	stationary = true
	force_look_at_target = true
	
	# TODO: cast
	print("--- Cast")
	
	await get_tree().create_timer(1.0).timeout
	
	# TODO: attack
	print("--- Attack")
	$DamageSplat.emitting = true
	
	stationary = false
	force_look_at_target = false
	$AttackCD.start()

func _ready() -> void:
	super()
	
	Utils.tick.connect(func():
		if target == Global.player and $AttackCD.is_stopped():
			if get_distance_to_player() < 1.5 and !stationary:
				attack())
	
	integrity_changed.connect(func():
		$DamageSplat.emitting = true)

func _physics_process(delta: float) -> void:
	super(delta)
	$NodeSpatial.global_position = get_bone_position(
		$AnguishedClaw/Skeleton3D, "Hand") + Vector3(0, 0.35, 0)
