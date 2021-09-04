extends Node2D

export var speed_x: float = 400.0
export var speed_y: float = 300.0

var velocity_y: float = speed_y

func _process(dt: float):
	var velocity = Vector2(0.0, velocity_y)
	if Input.is_action_pressed("player_right"):
		velocity.x += speed_x
	if Input.is_action_pressed("player_left"):
		velocity.x -= speed_y
	position += velocity * dt
	
	# If the player is vertically out of bounds, reverse their vertical velocity
	if position.y > Arena.y_max:
		var difference = position.y - Arena.y_max
		if difference > Arena.height:
			position.y = Arena.y_max
		else:
			position.y -= difference
		if velocity_y > 0:
			velocity_y *= -1.0
	elif position.y < Arena.y_min:
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
