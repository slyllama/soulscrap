@icon("res://generic/editor_icons/Handler.svg")
extends Node3D

const NodeSpatial = preload("res://lib/ui/node_spatial/node_spatial.tscn")

var _indicator_emission = 0.0

func _play_undertempo_warning() -> void:
	$TempoWarning.play()
	var _d = NodeSpatial.instantiate()
	_d.text = str("Undertempo")
	_d.font_size = 16
	_d.position.z = -0.35
	add_child(_d)
	_d.float_away()

func _clear_buffer() -> void:
	for _n in $ProjectileBuffer.get_children():
		_n.queue_free()

func _ready() -> void:
	PlayerData.aggro_gained.connect(func():
		_indicator_emission = 1.0)
	
	PlayerData.aggro_lost.connect(func():
		_indicator_emission = 0.0)
	
	PlayerData.deck_changed.connect(func():
		# Clear out the projectile buffer and replace it with any projectile
		# specified in the component data
		var _id = PlayerData.current_deck[0].id
		var _data = Components.component_library[_id]
		_clear_buffer()
		if "projectile" in _data:
			var _p = _data.projectile.instantiate()
			$ProjectileBuffer.add_child(_p)
		
		# Adjust the range to match
		if "range" in _data:
			$RangeIndicator.size.x = _data.range * 2.0
			$RangeIndicator.size.z = _data.range * 2.0
			$AimArea/Collision.shape.size.z = _data.range
			$AimArea/Collision.position.z = -_data.range / 2.0
		)
	
	PlayerData.component_used.connect(func(id):
		var _data = Components.component_library[id]
		if "tempo_cost" in _data:
			if !PlayerData.change_tempo(-_data.tempo_cost):
				_play_undertempo_warning()
				return
		
		if $ProjectileBuffer.get_children():
			var _p = $ProjectileBuffer.get_children()[0]
			if _p is Projectile:
				var _q = _p.duplicate()
				add_child(_q)
				_q.visible = true
				_q.global_position = global_position
				_q.fire()
		
		PlayerData.projectile_fired.emit()
		
		for _b in $AimArea.get_overlapping_areas():
			if _b.name == "Hitbox":
				_b.get_parent().lose_integrity(Components.get_damage(id)))

func _process(_delta: float) -> void:
	$RangeIndicator.emission_energy = lerp(
		$RangeIndicator.emission_energy, _indicator_emission, Utils.clerp(15.0))
