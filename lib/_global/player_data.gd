extends Node

signal aggro_gained
signal aggro_lost
signal component_used(id: String)
signal damage_taken(amount: int)
signal deck_changed
signal projectile_fired
signal sprint_started
signal sprint_ended

var aggro_agents: int = 0
var current_deck: Array = []
var integrity = 100
var in_dodge = false
var tempo = 99

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
