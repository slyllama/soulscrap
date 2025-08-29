extends CanvasLayer

func set_highlight_value(_val) -> void:
	$Highlight.material.set_shader_parameter("value", _val)

func set_smoke_value(_val) -> void:
	$Smoke.material.set_shader_parameter("value", _val)

func _on_start_timer_timeout() -> void:
	var _t = create_tween()
	_t.tween_method(set_smoke_value, 0.0, 1.0, 0.6)
	_t.tween_callback(func(): layer = -1)

func _ready() -> void:
	$Debug.queue_free()
	
	PlayerData.projectile_fired.connect(func():
		var _t = create_tween()
		_t.tween_method(set_highlight_value, 0.0, 1.0, 0.3))
	PlayerData.damage_taken.connect(func(_amount):
		$TakeDamage.dissolve_scale = 0.0
		$TakeDamage.disappear(0.75))
	PlayerData.sprint_started.connect(func(): $Anime.appear(0.2))
	PlayerData.sprint_ended.connect(func(): $Anime.disappear(0.4))
	
	# Conditions
	PlayerData.condition_added.connect(func(_id):
		if _id == "poisoned": $Poison.appear())
	PlayerData.condition_ended.connect(func(_id):
		if _id == "poisoned": $Poison.disappear())
