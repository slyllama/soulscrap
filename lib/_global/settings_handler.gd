@icon("res://generic/editor_icons/CoreHandler.svg")
extends Node

signal propogated(param)

var settings = {
	"dof": false
}

func propogate(exceptions = []) -> void:
	await get_tree().process_frame
	for _p in settings:
		if !_p in exceptions:
			propogated.emit(_p)
