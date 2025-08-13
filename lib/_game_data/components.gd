extends Node
# Components library - names, etc

const ICON_PATH = "res://lib/ui/card_bar/card_icon/icons/"

const component_library = {
	"blank": {
		"title": "Blank",
		"texture": preload(ICON_PATH + "unknown.png")
	},
	"short_burst_projectile": {
		"title": "((Short Burst Projectile))",
		"description": "((Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.))",
		"texture": preload(ICON_PATH + "short_burst_projectile.png"),
		"tempo_cost": 20,
		"damage": 10
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
