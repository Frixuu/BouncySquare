extends Node2D

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

func _process(delta: float):
	var viewport_rect = get_viewport_rect()
	viewport_rect.get_area()
	screen_size = get_viewport_rect().size
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta

func on_collider_enter(_rid: int, other: Area2D, _other_idx: int, _this_idx: int):
	if StateManager.current_state == StateManager.State.PLAYING:
		StateManager.set_state(StateManager.State.DEAD)
		var other_sprite = other.get_node("Sprite")
		other_sprite.self_modulate = Color.red
