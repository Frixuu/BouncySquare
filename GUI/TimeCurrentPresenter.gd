extends Label

onready var tween: Tween = $Tween as Tween
var TimeFormatter = preload("res://GUI/TimeFormatter.gd").new()
var current_time: float = 0.0

func _ready():
	AutoRespawner.connect("half_second_left", self, "on_ready_to_respawn")
	
func on_ready_to_respawn():
	tween.interpolate_property(self, "current_time", current_time, 0.0, 0.5)
	tween.start()

func _process(_dt: float):
	if StateManager.current_state == StateManager.State.PLAYING:
		current_time = ScoreManager.get_time_current()
	self.text = TimeFormatter.format(current_time)
