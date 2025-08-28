extends Projectile

func fire() -> void:
	super()
	
	$Splash.emitting = true
	$Area/Decal.emission_energy = 10.0
	var _t = create_tween()
	_t.set_trans(Tween.TRANS_EXPO)
	_t.set_ease(Tween.EASE_OUT)
	_t.tween_property($Area/Decal, "emission_energy", 0.0, 0.3)
	await get_tree().create_timer(3.0).timeout
	destroy()

func _ready() -> void:
	super()
	$Area/Decal.emission_energy = 0.0
	var _t = create_tween()
	_t.tween_property($Area/Decal, "emission_energy", 0.85, 0.2)
	
	if damages_enemy:
		global_rotation = get_parent().global_rotation
		global_rotation.x = 0.0
