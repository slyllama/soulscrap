extends VBoxContainer

const CondIndicator = preload("res://lib/ui/conditions/cond_indicator.tscn")

func _ready() -> void:
	PlayerData.conditions_updated.connect(func():
		for _n in get_children(): _n.queue_free()
		for _condition in PlayerData.current_conditions:
			var _c = CondIndicator.instantiate()
			_c.cond_id = _condition.id
			_c.remaining_ticks = _condition.remaining_ticks
			add_child(_c))
	
	PlayerData.conditions_updated.emit() # first run
