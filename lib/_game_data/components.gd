extends Node
# Components library - names, etc

const component_library = {
	"test_component": {
		"title": "Test Component"
	}
}

func get_title(component: String) -> String:
	if component in component_library:
		return(component_library[component].title)
	else: return("")
