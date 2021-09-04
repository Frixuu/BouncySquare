extends Node2D

export var friction_x: float = 4000.0
export var speed_x: float = 500.0
export var speed_y: float = 425.0

var velocity_x: float = 0.0
var velocity_y: float = speed_y

signal went_too_high
signal went_too_low

func _process(dt: float):
	
	# Move only if is currently in Alive state
	if StateManager.current_state == StateManager.State.PLAYING:
		var curr_velocity_x: float = 0.0
		curr_velocity_x += Input.get_action_strength("player_right")
		curr_velocity_x -= Input.get_action_strength("player_left")
		curr_velocity_x *= speed_x
		
		var max_step: float = friction_x * dt
		var diff_x: float = curr_velocity_x - velocity_x
		if abs(diff_x) < max_step:
			velocity_x = curr_velocity_x
		else:
			if diff_x > 0:
				velocity_x += max_step
			else:
				velocity_x -= max_step
	
	# Apply calculated velocity
	var velocity = Vector2(velocity_x, velocity_y)
	position += velocity * dt
	
	# If the player is vertically out of bounds, reverse their vertical velocity
	if position.y > Arena.y_max:
		emit_signal("went_too_low")
		var difference = position.y - Arena.y_max
		if difference > Arena.height:
			position.y = Arena.y_max
		else:
			position.y -= difference
		if velocity_y > 0:
			velocity_y *= -1.0
	elif position.y < Arena.y_min:
		emit_signal("went_too_high")
		var difference = Arena.y_min - position.y
		if difference > Arena.height:
			position.y = Arena.y_min
		else:
			position.y += difference
		if velocity_y < 0:
			velocity_y *= -1.0
		
	# If the player is horizontally out of bounds, just wrap them
	if position.x > Arena.x_max:
		position.x -= Arena.width
	elif position.x < Arena.x_min:
		position.x += Arena.width
	

func on_collider_enter(_rid: int, other: Area2D, _other_idx: int, _this_idx: int):
	if StateManager.current_state == StateManager.State.PLAYING:
		StateManager.set_state(StateManager.State.DEAD)
		var other_sprite = other.get_node("Sprite")
		other_sprite.self_modulate = Color.red
