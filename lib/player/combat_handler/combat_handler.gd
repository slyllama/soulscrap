extends Node3D

func _ready() -> void:
	Global.component_used.connect(func(id):
		var _data = Components.component_library[id]
		if "tempo_cost" in _data:
			if !PlayerData.change_tempo(-_data.tempo_cost):
				return
		
		var _m = $MoltenMetal.duplicate()
		add_child(_m)
		_m.visible = true
		_m.global_position = global_position
		_m.fire()
		
		PlayerData.projectile_fired.emit()
		
		for _b in$AimArea.get_overlapping_bodies():
			if _b is Agent:
				_b.lose_integrity(Components.get_damage(id)))
