extends Node3D

func _ready() -> void:
	Global.component_used.connect(func(id):
		print(id))
