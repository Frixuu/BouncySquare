extends Label

var TimeFormatter = preload("res://GUI/TimeFormatter.gd").new()

func _process(dt: float):
	var time_seconds = ScoreManager.get_time_current()
	self.text = TimeFormatter.format(time_seconds)
