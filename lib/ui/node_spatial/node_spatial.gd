extends VisibleOnScreenNotifier3D

@export var text = "((Spatial Text))"
@export var text_color = Color.WHITE
@export var bar_active = false
@export var bar_value = 100.0

@onready var og_text_pos = $Canvas/Root2D/Text.position.y

func float_away(time = 0.5) -> void:
	$Canvas/Root2D/Text.modulate.a = 1.0
	var _f = create_tween()
	_f.tween_property($Canvas/Root2D/Text, "position:y", og_text_pos - 20.0, time)
	var _a = create_tween()
	_a.set_parallel()
	_a.tween_property($Canvas/Root2D/Text, "modulate:a", 0.0, time)

func update_value(val: int) -> void:
	bar_value = val
	$Canvas/Root2D/Bar.value = bar_value

func update_appearance() -> void:
	$Canvas/Root2D/Bar.visible = bar_active
	$Canvas/Root2D/Text.self_modulate = text_color
	$Canvas/Root2D/Text.text = text

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_home"):
		float_away()

func _ready() -> void:
	update_appearance()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if is_on_screen():
		var _pos = Global.camera.unproject_position(self.global_position)
		$Canvas/Root2D.position = _pos
		$Canvas/Root2D.visible = true
		for _n: Control in $Canvas/Root2D.get_children():
			_n.position.x = -_n.size.x / 2.0
	else: $Canvas/Root2D.visible = false
