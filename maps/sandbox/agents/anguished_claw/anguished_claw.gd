extends Agent

func _ready() -> void:
	super()
	
	integrity_changed.connect(func():
		$DamageSplat.emitting = true)

func _physics_process(delta: float) -> void:
	super(delta)
	$NodeSpatial.global_position = get_bone_position(
		$AnguishedClaw/Skeleton3D, "Hand") + Vector3(0, 0.35, 0)
