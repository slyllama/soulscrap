extends CanvasLayer

var target_scene = "res://maps/sandbox/sandbox.tscn"

var loading_status: int
var progress: Array[float]
var finished_loading = false

func _change_scene() -> void:
	if !finished_loading: return
	get_tree().change_scene_to_packed(
		ResourceLoader.load_threaded_get(target_scene))

func _transition() -> void:
	var _t = create_tween()
	_t.tween_property($Fade, "modulate:a", 1.0, 0.3)
	_t.tween_callback(_change_scene)

func _input(_event: InputEvent) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _ready() -> void:
	ResourceLoader.load_threaded_request(target_scene)

func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	match loading_status:
		ResourceLoader.THREAD_LOAD_LOADED:
			if finished_loading: return
			finished_loading = true
			_transition()
		ResourceLoader.THREAD_LOAD_FAILED:
			Utils.pdebug("[Loader] load failed.", "red")
