extends Node

enum State { MAIN_MENU, PLAYING, PAUSED, DEAD }
export var current_state = State.MAIN_MENU
signal state_changed(prev_value, new_value)

func _ready():
	pass # Replace with function body.

func set_state(new_state: int):
	if current_state != new_state:
		var prev_state = current_state
		current_state = new_state
		emit_signal("state_changed", prev_state, new_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float):
#	pass
