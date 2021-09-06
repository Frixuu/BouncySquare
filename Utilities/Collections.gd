extends Node

## Returns a random element of the array.
func random(arr: Array):
	return arr[randi() % arr.size()]
