extends CharacterBody3D

func _physics_process(_delta: float) -> void:
	velocity.y += Global.GRAVITY
	move_and_slide()
