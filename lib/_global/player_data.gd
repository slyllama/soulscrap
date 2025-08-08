extends Node

signal damage_taken

var tempo = 100
var resilience = 100

# Returns true is a change was effected
func change_tempo(amount: int = -1) -> bool:
	if tempo < 0 or tempo > 100: # one tick of a negative value is technically allowed
		tempo = clamp(tempo, 0, 100)
		return(false)
	tempo += amount
	return(true)
