extends Node

var tempo = 100

# Returns true is a change was effected
func change_tempo(amount: int = -1) -> bool:
	if tempo + amount < 0 or tempo + amount > 100:
		return(false)
	tempo += amount
	return(true)
