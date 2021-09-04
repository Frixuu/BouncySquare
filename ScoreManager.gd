extends Node

var session_started: int = 0
var session_ended: int = 0
var session_active: bool = false
var score_best: int = 0
	
func _ready():
	StateManager.connect("died", self, "session_end")
	StateManager.connect("respawned", self, "session_start")
	score_best = load_best_score()
	
func get_time_current() -> float:
	return float(get_time_current_usec()) / 1000000.0

func get_time_current_usec() -> int:
	return session_ended - session_started
	
func get_time_best() -> float:
	return float(get_time_best_usec()) / 1000000.0

func get_time_best_usec() -> int:
	return score_best
	
func session_start():
	session_started = OS.get_ticks_usec()
	session_ended = session_started
	session_active = true
	
func session_end():
	session_ended = OS.get_ticks_usec()
	session_active = false
	print("Time: %f seconds" % get_time_current())
	update_best_score()
	if get_time_best_usec() == get_time_current_usec():
		print("(This was new best time)")
		save_best_score()

func update_best_score():
	var score_current = get_time_current_usec()
	if score_current >= score_best:
		score_best = score_current
		
func load_best_score() -> int:
	var save = File.new()
	
	if not save.file_exists("user://best.save"):
		print("Save file does not exist")
		return 0
		
	save.open("user://best.save", File.READ)
	
	if save.get_position() >= save.get_len():
		printerr("Save file exists, but is empty")
		return 0
		
	var save_data = parse_json(save.get_line())
	save.close()
	
	var best = int(save_data["best"])
	print("Loaded save data, best time is %f seconds" % (float(best) / 1000000.0))
	return best
	
func save_best_score():
	var save = File.new()
	save.open("user://best.save", File.WRITE)
	save.store_line(to_json({ "best": get_time_best_usec() }))
	save.close()
	
func _process(_dt: float):
	if session_active:
		session_ended = OS.get_ticks_usec()
		update_best_score()
