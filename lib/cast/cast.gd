extends ProgressBar

var running = false
var _time = 1.0

func stop_cast(successful = true) -> void:
	$CastTimer.stop()
	get_parent().get_parent().disappear()
	running = false
	
	Global.cast_stopped.emit(successful)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_page_up"):
		Global.start_cast.emit(2.0)

func _ready() -> void:
	value = 0.0
	PlayerData.damage_taken.connect(func(_amount):
		stop_cast(false))
	
	Global.start_cast.connect(func(get_time):
		get_parent().get_parent().appear()
		running = true
		_time = get_time
		$CastTimer.start(_time))

func _process(_delta: float) -> void:
	if !running: return
	value = (1.0 - ($CastTimer.time_left / _time)) * 100.0
	if Global.player.velocity.length() > 1.0:
		stop_cast(false)

func _on_cast_timer_timeout() -> void:
	stop_cast()
