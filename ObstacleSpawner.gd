extends CanvasItem

const Obstacle = preload("res://Obstacle.gd")
const ObstacleSpawnData = preload("res://ObstacleSpawnData.gd")
const ObstaclePrefab = preload("res://Obstacle.tscn")

var active: bool = false
var spawn_queue: Array = []
var pattern_countdown: int = 3

func _ready():
	StateManager.connect("died", self, "on_player_died")
	StateManager.connect("respawned", self, "on_player_respawned")

func on_player_died():
	active = false
	
func on_player_respawned():
	active = true
	spawn_queue.clear()
	
func on_theme_changed(curr_theme, _next_theme):
	self.modulate = (curr_theme as GameTheme).obstacle_color

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
		
	if spawn_queue.empty():
		if pattern_countdown <= 0 && randi() % 4 == 0:
			pattern_countdown = 3
			queue_pattern()
		else:
			pattern_countdown -= 1
			queue_single_random()
		
func compute_suggested_timer() -> float:
	return 1.5 - min(0.8, ScoreManager.get_time_current() * 0.013)
	
func queue_single_random():
	var spawn_data = ObstacleSpawnData.new()
	spawn_data.timer = compute_suggested_timer()
	spawn_data.speed = Vector2(random([300.0, -300.0]), 0.0)
	spawn_data.initial_position = Vector2(spawn_data.speed.x * -2.0, random([96.0, 48.0, 0.0, -48.0, -96.0]))
	spawn_queue.push_back(spawn_data)
	
func queue_pattern():
	var pattern_index = randi() % 1
	var spawn_data: ObstacleSpawnData
	match pattern_index:
		0:
			var pos_y = random([96.0, -96.0])
			
			spawn_data = ObstacleSpawnData.new()
			spawn_data.timer = compute_suggested_timer()
			spawn_data.speed = Vector2(random([300.0, -300.0]), 0.0)
			spawn_data.initial_position = Vector2(spawn_data.speed.x * -2.0, pos_y)
			spawn_queue.push_back(spawn_data)
			
			spawn_data = copy_data(spawn_data)
			spawn_data.speed *= -1.0
			spawn_data.initial_position.x *= -1.0
			spawn_queue.push_back(spawn_data)
			
			spawn_data = copy_data(spawn_data)
			spawn_data.initial_position.y = 0.0
			spawn_data.timer += compute_suggested_timer()
			spawn_queue.push_back(spawn_data)
			
			spawn_data = copy_data(spawn_data)
			spawn_data.speed *= -1.0
			spawn_data.initial_position.x *= -1.0
			spawn_queue.push_back(spawn_data)
			
			spawn_data = copy_data(spawn_data)
			spawn_data.initial_position.y = -pos_y
			spawn_data.timer += compute_suggested_timer()
			spawn_queue.push_back(spawn_data)
			
			spawn_data = copy_data(spawn_data)
			spawn_data.speed *= -1.0
			spawn_data.initial_position.x *= -1.0
			spawn_queue.push_back(spawn_data)

func copy_data(data: ObstacleSpawnData) -> ObstacleSpawnData:
	var copy = ObstacleSpawnData.new()
	copy.initial_position = data.initial_position
	copy.speed = data.speed
	copy.timer = data.timer
	return copy

func random(arr: Array):
	return arr[randi() % arr.size()]
