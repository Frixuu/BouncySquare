extends Sprite

export var starting_color: Color = Color.transparent
onready var tween: Tween = $Tween as Tween

func _ready():
	self.self_modulate = starting_color
	var _err = BoundaryManager.connect("color_change", self, "on_color_change")

func on_color_change(color: Color, duration: float):
	if duration == 0.0:
		self.self_modulate = color
	else:
		tween.interpolate_property(self, "self_modulate",
			self.self_modulate, color, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
