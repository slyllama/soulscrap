@icon("res://generic/editor_icons/CoreHandler.svg")
extends Node

const SETTINGS_PATH = "user://settings.dat"

signal propogated(param)

var settings = {
	"dof": "false"
}

func change(param: String, value: String) -> void:
	settings[param] = value
	propogate()
	save()

func open() -> void:
	if !FileAccess.file_exists(SETTINGS_PATH):
		save()
		return
	var _f = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	settings = _f.get_var()
	_f.close()
	SettingsHandler.propogate()

func save() -> void:
	var _f = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	_f.store_var(settings)
	_f.close()

func propogate(exceptions = []) -> void:
	await get_tree().process_frame
	for _p in settings:
		if !_p in exceptions:
			propogated.emit(_p)
