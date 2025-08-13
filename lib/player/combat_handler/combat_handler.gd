extends Node3D

func _ready() -> void:
	Global.component_used.connect(func(id):
		for _b in$AimArea.get_overlapping_bodies():
			if _b is Agent:
				_b.lose_integrity(Components.get_damage(id)))
