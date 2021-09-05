extends AudioStreamPlayer2D

onready var tween: Tween = $Tween as Tween

func _ready():
	var _err
	_err = StateManager.connect("state_changed", self, "on_state_changed")
	_err = AutoRespawner.connect("half_second_left", self, "revert_pitch")
	
func on_state_changed(_prev_state, new_state):
	if new_state == StateManager.State.PLAYING:
		resume()
	elif new_state == StateManager.State.DEAD:
		lower_pitch()
	else:
		pause()

func lower_pitch():
	tween.stop(self)
	tween.interpolate_property(self, "pitch_scale",
		1.0, 0.5, 1.4,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
func revert_pitch():
	if self.pitch_scale < 1.0:
		tween.stop(self)
		tween.interpolate_property(self, "pitch_scale",
			self.pitch_scale, 1.0, 0.5,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()

func pause():
	self.stream_paused = true

func resume():
	if not self.playing:
		self.playing = true
	self.stream_paused = false
	
