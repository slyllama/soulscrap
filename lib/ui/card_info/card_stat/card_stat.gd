extends PanelContainer

@export var icon = load("res://lib/ui/card_bar/card_icon/icons/unknown.png")
@export var description = "((Description))"

func _ready() -> void:
	$HBox/Icon.texture = icon
	$HBox/Description.text = description
