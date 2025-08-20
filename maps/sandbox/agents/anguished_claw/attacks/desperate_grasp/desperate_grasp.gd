extends Projectile

func fire() -> void:
	print("firing")
	for _n in $Area.get_overlapping_bodies():
		if _n is Player: PlayerData.take_damage(damage)
	
	var _t = create_tween()
	_t.tween_property($Decal, "emission_energy", 0.0, 0.03)
	await _t.finished
	super()

func _ready() -> void:
	$Decal.emission_energy = 0.0
	
	super()
	var _t = create_tween()
	_t.tween_property($Decal, "emission_energy", 1.0, 0.2)
