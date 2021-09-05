extends Node

const Obstacle = preload("res://Obstacle.gd")
const ObstacleSpawnData = preload("res://ObstacleSpawnData.gd")
const ObstaclePrefab = preload("res://Obstacle.tscn")

var active: bool = false
var spawn_queue: Array = []
var spawn_color: Color

func _ready():
	StateManager.connect("died", self, "on_player_died")
	StateManager.connect("respawned", self, "on_player_respawned")

func on_player_died():
	active = false
	
func on_player_respawned():
	active = true
	
func on_theme_changed(curr_theme, _next_theme):
	spawn_color = (curr_theme as GameTheme).obstacle_color

func _process(dt: float):
	
	if not active:
		return
	
	for data in spawn_queue:
		var spawn_data = data as ObstacleSpawnData
		spawn_data.timer -= dt
		
	while spawn_queue.size() > 0 && spawn_queue.front().timer <= 0.0:
		var spawn_data = spawn_queue.pop_front() as ObstacleSpawnData
		var obstacle = ObstaclePrefab.instance()
		self.add_child(obstacle)
		obstacle.position = spawn_data.initial_position
		(obstacle as Obstacle).speed = spawn_data.speed
		obstacle.get_node("Sprite").self_modulate = spawn_color
		
	if spawn_queue.empty():
		var spawn_data = ObstacleSpawnData.new()
		spawn_data.timer = 1.5
		spawn_data.speed = Vector2(random([300.0, -300.0]), 0.0)
		spawn_data.initial_position = Vector2(spawn_data.speed.x * -2.0, random([96.0, 48.0, 0.0, -48.0, -96.0]))
		spawn_queue.push_back(spawn_data)
		
func random(arr: Array):
	return arr[randi() % arr.size()]
