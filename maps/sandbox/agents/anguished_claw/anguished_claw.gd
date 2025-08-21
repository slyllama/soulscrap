extends Agent

@onready var _anim: AnimationPlayer = model.get_node("AnimationPlayer")

func attack() -> void:
	stationary = true
	look_at_target_paused = true
	
	var _a = emit_attack("desperate_grasp")
	_anim.speed_scale = 1.0 / _a.cast_time
	_anim.play("desperate_grasp")
	await _anim.animation_finished
	_anim.speed_scale = 1.0
	
	stationary = false
	look_at_target_paused = false
	$AttackCD.start()

func _ready() -> void:
	super()
	
	_anim.set_blend_time("idle", "desperate_grasp", 0.5)
	_anim.set_blend_time("desperate_grasp", "idle", 0.2)
	_anim.animation_finished.connect(func(_anim_name):
		if _anim_name == "desperate_grasp":
			_anim.play("idle"))
	
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
