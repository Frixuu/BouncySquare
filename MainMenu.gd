extends Node

func _ready():
	var _err = StateManager.connect("state_changed", self, "on_state_changed")

func on_state_changed(prev_state, _new_state):
	if prev_state == StateManager.State.MAIN_MENU:
		StateManager.disconnect("state_changed", self, "on_state_changed")
		BoundaryManager.change_color_smoothly(Color.white, 0.5)
		var tween = $Tween
		tween.interpolate_property(self, "modulate",
			Color.white, Color.transparent, 0.2,
			Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.interpolate_callback(self, 0.2, "destroy")
		tween.start()

func destroy():
	get_parent().remove_child(self)

func _process(_dt: float):
	if Input.is_action_pressed("ui_accept"):
		StateManager.set_state(StateManager.State.PLAYING)
