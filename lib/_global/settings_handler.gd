@icon("res://generic/editor_icons/CoreHandler.svg")
extends Node

signal propogated(param)

var settings = {
	"dof": "false"
}

func change(param: String, value: String) -> void:
	settings[param] = value
	propogate()

func propogate(exceptions = []) -> void:
	await get_tree().process_frame
	for _p in settings:
		if !_p in exceptions:
			propogated.emit(_p)
