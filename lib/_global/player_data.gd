extends Node

signal aggro_gained
signal aggro_lost
signal component_used(id: String)
signal damage_taken(amount: int)
signal deck_changed
signal evaded # projectile was successfully dodged
signal projectile_fired
signal sprint_started
signal sprint_ended

var aggro_agent_count: int = 0
var current_deck: Array = []
var integrity = 100
var in_dodge = false
var tempo = 99

func add_to_deck(id) -> bool:
	for _card_data in current_deck:
		var _card: CardIcon = _card_data.node
		if _card_data.id == id:
			_card.quantity += 1
			_card.update()
			return(true)
		elif _card_data.id == "blank":
			print("doing this")
			print(id)
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
	deck_changed.connect(func():
		print(current_deck))
