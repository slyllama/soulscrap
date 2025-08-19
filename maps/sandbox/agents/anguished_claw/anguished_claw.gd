extends Agent

func attack() -> void:
	stationary = true
	force_look_at_target = true
	
	# TODO: cast
	print("--- Cast")
	await get_tree().create_timer(0.35).timeout
	
	# TODO: attack
	print("--- Attack")
	model.get_node("AnimationPlayer").play("take_damage")
	$DamageSplat.emitting = true
	
	stationary = false
	force_look_at_target = false
	$AttackCD.start()

func _ready() -> void:
	super()
	
	model.position.y = -1.0
	var _t = create_tween() # janky spawn animation, LMAO
	_t.set_ease(Tween.EASE_IN_OUT)
	_t.set_trans(Tween.TRANS_EXPO)
	_t.tween_property(model, "position:y", 0.0, 0.3)
	
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
