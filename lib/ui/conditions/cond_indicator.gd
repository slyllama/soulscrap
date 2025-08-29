extends HBoxContainer

var _target_duration_state = 100.0

@export var cond_id: String:
	get: return(cond_id)
	set(_val):
		cond_id = _val
		$VBox/Text.text = Components.get_cond_title(cond_id)

@export var remaining_ticks: int:
	get: return(remaining_ticks)
	set(_val):
		remaining_ticks = _val
		var _total_ticks = float(Components.condition_library[cond_id].ticks)
		var _ratio = float(remaining_ticks) /_total_ticks
		_target_duration_state = clamp(_ratio * 100.0, 0.0, 100.0)
		$VBox/CastTexture/CastBar.value = _target_duration_state
