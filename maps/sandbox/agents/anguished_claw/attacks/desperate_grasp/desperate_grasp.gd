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
	
	var _t = create_tween()
	_t.tween_property($Area/Decal, "emission_energy", 0.0, 0.03)
	await _t.finished
	super()

func _ready() -> void:
	$Area/Decal.emission_energy = 0.0
	
	super()
	var _t = create_tween()
	_t.tween_property($Area/Decal, "emission_energy", 1.0, 0.2)
