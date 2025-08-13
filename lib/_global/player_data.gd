extends Node

signal damage_taken

var tempo = 99
var integrity = 100

# Returns true is a change was effected
func change_tempo(amount: int = -1) -> bool:
	if tempo + amount < 0 or tempo + amount > 100: # one tick of a negative value is technically allowed
		tempo = clamp(tempo, 0, 100)
		return(false)
	tempo += amount
	return(true)
