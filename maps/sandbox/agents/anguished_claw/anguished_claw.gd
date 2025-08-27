extends Agent

@onready var _anim: AnimationPlayer = model.get_node("AnimationPlayer")
@export var wander_targets: Array[Marker3D] = []

var _s = true

func attack() -> void:
	stationary = true
	look_at_target_paused = true
	_s = !_s
	
	var _a
	if _s: _a = emit_attack("molten_shot")
	else: _a = emit_attack("desperate_grasp")
	
	_anim.speed_scale = clamp(1.0 / _a.cast_time, 0.5, 1.5)
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
	_t.tween_property(model, "position:y", -0.2, 0.3)
	
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

func _on_target_reached() -> void:
	return
	#target = null
	## Spare frame to reset target, in case the elected target is the same
	#await get_tree().process_frame
	#if wander_targets.size() == 0: return # no valid wandering targets
	#var _t = randi_range(0, wander_targets.size() - 1)
	#target = wander_targets[_t]
