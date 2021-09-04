extends AudioStreamPlayer2D

onready var tween: Tween = $Tween as Tween

func _ready():
	var _err = StateManager.connect("state_changed", self, "on_state_changed")
	
func on_state_changed(_prev_state, new_state):
	if new_state == StateManager.State.PLAYING:
		resume()
	elif new_state == StateManager.State.DEAD:
		lower_pitch()
	else:
		pause()

func lower_pitch():
	tween.stop(self)
	tween.interpolate_property(self, "pitch_scale", 1.0, 0.5, 1)
	tween.start()

func pause():
	self.stream_paused = true

func resume():
	if self.pitch_scale < 1.0:
		tween.stop(self)
		tween.interpolate_property(self, "pitch_scale", self.pitch_scale, 1.0, 0.1)
		tween.start()
	self.playing = true
	self.stream_paused = false
	
