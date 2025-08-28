extends Node
# Components library - names, etc

const ICON_PATH = "res://lib/ui/deck/card_icon/icons/"
const PROJECTILE_PATH = "res://lib/projectiles/"

const condition_library = {
	"blank": {
		"title": "Blank"
	},
	"poisoned": {
		"title": "Poisoned"
	}
}

const component_library = {
	"blank": {
		"title": "Blank",
		"texture": preload(ICON_PATH + "unknown.png")
	},
	"molten_shot": {
		"title": "Molten Shot",
		"description": "Fire a super-heated blob of scrap metal.",
		"texture": preload(ICON_PATH + "molten_shot.png"),
		"projectile": preload(PROJECTILE_PATH + "molten_shot.tscn"),
		"tempo_cost": 20,
		"damage": 15,
		"cooldown": 0.4,
		"range": 2.3 # given in meters
	},
	"test_item": {
		"title": "((Test Item))",
		"description": "((Description))",
		"texture": preload(ICON_PATH + "test_item.png"),
		"projectile": preload("res://maps/sandbox/agents/anguished_claw/attacks/desperate_grasp/desperate_grasp.tscn"),
		"cooldown": 5.0,
		"range": 2.0
	},
	"anguished_egg": {
		"title": "Anguished Egg",
		"description": "((Description))",
		"texture": preload(ICON_PATH + "anguished_egg.png")
	},
	"desperate_grasp": {
		"title": "Desperate Grasp",
		"projectile": preload("res://maps/sandbox/agents/anguished_claw/attacks/desperate_grasp/desperate_grasp.tscn"),
		"damage": 25,
		"tempo_cost": 20
	}
}

#region Condition data
func get_cond_title(cond: String) -> String:
	if cond in condition_library:
		return(condition_library[cond].title)
	else: return("")
#endregion

#region Component data
func get_title(component: String) -> String:
	if component in component_library:
		return(component_library[component].title)
	else: return("")

func get_description(component: String) -> String:
	if component in component_library:
		if "description" in component_library[component]:
			return(component_library[component].description)
		else: return("")
	else: return("")

func get_texture(component: String) -> Texture2D:
	if component in component_library:
		if "texture" in component_library[component]:
			return(component_library[component].texture)
		else: return(component_library["blank"].texture)
	else: return(component_library["blank"].texture)

func get_range(component: String) -> float:
	if component in component_library:
		if "range" in component_library[component]:
			return(component_library[component].range)
		else: return(0.0)
	else: return(0.0)

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
#endregion
