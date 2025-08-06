extends DissolveControl

func _ready() -> void:
	super()
	
	Global.mouse_capture_lost.connect(func():
		$Motes.emitting = true
		appear())
	
	Global.mouse_capture_gained.connect(func():
		$Motes.emitting = false
		disappear())
	
	get_window().size_changed.connect(func():
		$Motes.global_position.x = get_window().size.x / 2.0)
	
	# Initialise
	$Motes.emitting = false
	$Motes.global_position.x = get_window().size.x / 2.0
	_set_dissolve(0.0)
