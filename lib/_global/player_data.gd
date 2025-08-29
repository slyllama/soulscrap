extends Node

signal aggro_gained
signal aggro_lost
signal component_used(id: String)
signal conditions_updated
signal condition_added(id)
signal condition_ended(id)
signal damage_taken(amount: int)
signal deck_changed
signal evaded # projectile was successfully dodged
signal projectile_fired
signal sprint_started
signal sprint_ended

var aggro_agent_count: int = 0
var current_deck: Array = []
var current_conditions: Array = []
var integrity = 100
var in_dodge = false
var tempo = 99

func add_condition(id):
	var _data = Components.condition_library[id]
	for _c in current_conditions:
		if _c.id == id:
			_c.remaining_ticks = _data.ticks
			return
	condition_added.emit(id)
	current_conditions.append({
		"id": id,
		"remaining_ticks": _data.ticks
	})

func has_condition(id) -> bool:
	for _c in current_conditions:
		if _c.id == id: return(true)
	return(false)

func add_to_deck(id) -> bool:
	for _card_data in current_deck:
		var _card: CardIcon = _card_data.node
		if _card_data.id == id:
			_card.quantity += 1
			_card.update()
			return(true)
		elif _card_data.id == "blank":
			_card.update(id)
			return(true)
	return(false)

func update_aggro_state(change: bool = true) -> void:
	var _prev_aggro_agent_count = aggro_agent_count
	if change == true: aggro_agent_count += 1
	else: aggro_agent_count -= 1
	
	aggro_agent_count = clamp(aggro_agent_count, 0, INF)
	if _prev_aggro_agent_count == 0 and aggro_agent_count > 0:
		aggro_gained.emit()
	elif _prev_aggro_agent_count > 0 and aggro_agent_count == 0:
		aggro_lost.emit()

# Returns true is a change was effected
func change_tempo(amount: int = -1) -> bool:
	var _v = false
	if amount < 0:
		if tempo + amount >= 0: _v = true
	if amount > 0:
		if tempo + amount <= 100: _v = true
	if _v: tempo += amount
	return(_v)

func take_damage(amount: int) -> bool:
	if integrity - amount < 0:
		return(false)
	else:
		integrity -= amount
		damage_taken.emit(amount)
		return(true)

func _ready() -> void:
	Utils.tick.connect(func():
		var _last_current_conditions = current_conditions.duplicate()
		var _inc = false
		for _condition in current_conditions:
			if _condition.remaining_ticks > 1:
				_condition.remaining_ticks -= 1
				_inc = true
			else:
				condition_ended.emit(_condition.id)
				current_conditions.erase(_condition)
		if current_conditions != _last_current_conditions or _inc:
			conditions_updated.emit())
