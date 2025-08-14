extends Node
# Components library - names, etc

const ICON_PATH = "res://lib/ui/card_bar/card_icon/icons/"

const component_library = {
	"blank": {
		"title": "Blank",
		"texture": preload(ICON_PATH + "unknown.png")
	},
	"molten_shot": {
		"title": "Molten Shot",
		"description": "Fire a super-heated blob of scrap metal.",
		"texture": preload(ICON_PATH + "molten_shot.png"),
		"tempo_cost": 20,
		"damage": 10,
		"cooldown": 0.5
	},
	"test_item": {
		"title": "((Test Item))",
		"description": "((Description))",
		"texture": preload(ICON_PATH + "test_item.png"),
		"cooldown": 5.0
	}
}

func get_title(component: String) -> String:
	if component in component_library:
		return(component_library[component].title)
	else: return("")

func get_description(component: String) -> String:
	if component in component_library:
		return(component_library[component].description)
	else: return("")

func get_texture(component: String) -> Texture2D:
	if component in component_library:
		return(component_library[component].texture)
	else: return(component_library["blank"].texture)

func get_damage(component: String) -> int:
	if component in component_library:
		if "damage" in component_library[component]:
			return(component_library[component].damage)
		else: return(0)
	else: return(0)

func get_cooldown(component: String) -> float:
	if component in component_library:
		if "cooldown" in component_library[component]:
			return(component_library[component].cooldown)
		else: return(0.0)
	else: return(0.0)
