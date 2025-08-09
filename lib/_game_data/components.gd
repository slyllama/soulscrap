extends Node
# Components library - names, etc

const component_library = {
	"blank": {
		"title": "Blank",
		"texture": preload("res://lib/ui/card_bar/card_icon/icons/icon_unknown.png")
	},
	"test_component": {
		"title": "Test Component",
		"texture": preload("res://lib/ui/card_bar/card_icon/icons/icon_test_component.png"),
		"tempo_cost": 20
	}
}

func get_title(component: String) -> String:
	if component in component_library:
		return(component_library[component].title)
	else: return("")

func get_texture(component: String) -> Texture2D:
	if component in component_library:
		return(component_library[component].texture)
	else: return(component_library["blank"].texture)
