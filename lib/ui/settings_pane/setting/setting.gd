extends VBoxContainer

@export var title = "((Setting))"
@export var id: String
@export var setting_aliases: Array[SettingAlias]

var current_value: SettingAlias
var value_count = 0

func _update() -> void:
	if !setting_aliases:
		Utils.pdebug("No setting aliases set.", "Setting", Utils.PCOLOR_DEBUG)
		return
	if value_count == 0:
		Utils.pdebug("No setting aliases set.", "Setting", Utils.PCOLOR_DEBUG)
		return
	
	$Box/SettingName.text = title + ":   [color=white]" + current_value.title + "[/color]"
	SettingsHandler.change(id, current_value.id)

func _ready() -> void:
	if !setting_aliases: return
	value_count = setting_aliases.size()
	if value_count > 0:
		current_value = setting_aliases[0]
		_update()

func _on_left_mouse_entered() -> void: Global.mouse_in_ui = true
func _on_right_mouse_entered() -> void: Global.mouse_in_ui = true

func _on_right_button_down() -> void:
	var _ind = setting_aliases.find(current_value)
	if _ind < value_count - 1:
		current_value = setting_aliases[_ind + 1]
	else: current_value = setting_aliases[0]
	_update()

func _on_left_button_down() -> void:
	var _ind = setting_aliases.find(current_value)
	if _ind > 0:
		current_value = setting_aliases[_ind - 1]
	else: current_value = setting_aliases[value_count - 1]
	_update()
