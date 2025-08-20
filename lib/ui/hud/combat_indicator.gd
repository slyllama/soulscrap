extends DissolveControl

func _update_mote_pos() -> void: # Keep in center even when using retina scaling
	$Motes.global_position.x = get_window().size.x / get_window().content_scale_factor * 0.5

func _ready() -> void:
	super()
	
	PlayerData.aggro_gained.connect(func():
		$Motes.emitting = true
		appear())
	
	PlayerData.aggro_lost.connect(func():
		$Motes.emitting = false
		disappear())
	
	get_window().size_changed.connect(_update_mote_pos)
	
	# Initialise
	$Motes.emitting = false
	_update_mote_pos()
	_set_dissolve(0.0)
