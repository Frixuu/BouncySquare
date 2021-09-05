extends Node

export var speed: Vector2 = Vector2(0.0, 0.0)

func _process(dt: float):
	if StateManager.current_state == StateManager.State.PLAYING:
		var parent = get_parent()
		(parent as Node2D).position += speed * dt
