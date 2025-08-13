extends PanelContainer

@export var icon: Texture2D = load("res://lib/ui/card_bar/card_icon/icons/unknown.png"):
	get: return(icon)
	set(_val):
		icon = _val
		_update()
@export var description = "((Description))":
	get: return(description)
	set(_val):
		description = _val
		_update()

func _update() -> void:
	$HBox/Icon.texture = icon
	$HBox/Description.text = description

func _ready() -> void:
	_update()
