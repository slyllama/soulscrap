extends VisibleOnScreenNotifier3D

@export var text = "((Spatial Text))"
@export var text_color = Color.WHITE

func _ready() -> void:
	$Canvas/Root2D/Text.text = text
	$Canvas/Root2D/Text.self_modulate = text_color

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if is_on_screen():
		var _pos = Global.camera.unproject_position(self.global_position)
		$Canvas/Root2D.position = _pos
		$Canvas/Root2D.visible = true
		for _n: Control in $Canvas/Root2D.get_children():
			_n.position.x = -_n.size.x / 2.0
	else: $Canvas/Root2D.visible = false
