extends HBoxContainer

@export var cond_id: String:
	get: return(cond_id)
	set(_val):
		cond_id = _val
		$Text.text = Components.get_cond_title(cond_id)
