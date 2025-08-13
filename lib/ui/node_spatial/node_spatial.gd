extends VisibleOnScreenNotifier3D

@export var text = "((Spatial Text))":
	get: return(text)
	set(_val):
		text = _val
		$Canvas/Root2D/Text.text = text
@export var text_color = Color.WHITE:
	get: return(text_color)
	set(_val):
		text_color = _val
		$Canvas/Root2D/Text.self_modulate = text_color
@export var bar_value = 100.0:
	get: return(bar_value)
	set(_val):
		bar_value = _val
		$Canvas/Root2D/Bar.value = bar_value

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if is_on_screen():
		var _pos = Global.camera.unproject_position(self.global_position)
		$Canvas/Root2D.position = _pos
		$Canvas/Root2D.visible = true
		for _n: Control in $Canvas/Root2D.get_children():
			_n.position.x = -_n.size.x / 2.0
	else: $Canvas/Root2D.visible = false
