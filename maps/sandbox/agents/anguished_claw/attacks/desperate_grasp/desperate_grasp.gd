extends Projectile

const _NodeSpatial = preload("res://lib/ui/node_spatial/node_spatial.tscn")

func fire() -> void:
	for _n in $Area.get_overlapping_bodies():
		if _n is Player:
			if PlayerData.in_dodge: # TODO: make more modular (incorporate into projectile.gd)
				print("Dodge")
				PlayerData.change_tempo(20)
				var _d = _NodeSpatial.instantiate()
				_d.text = str("Dodge!")
				_d.font_size = 24
				_d.text_color = Color.GOLD
				Global.player.add_child(_d)
				_d.position.y += 1.0
				#_d.global_position = Global.player.global_position
				_d.float_away()
			else:
				PlayerData.take_damage(damage)
	
	$Splash.emitting = true
	$Area/Decal.emission_energy = 10.0
	var _t = create_tween()
	_t.set_trans(Tween.TRANS_EXPO)
	_t.set_ease(Tween.EASE_OUT)
	_t.tween_property($Area/Decal, "emission_energy", 0.0, 0.3)
	await $Splash.finished
	super()

func _ready() -> void:
	$Area/Decal.emission_energy = 0.0
	
	super()
	var _t = create_tween()
	_t.tween_property($Area/Decal, "emission_energy", 0.85, 0.2)
