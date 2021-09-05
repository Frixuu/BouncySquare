extends Control

onready var tween: Tween = $Tween as Tween

func _ready():
	self.modulate = Color.transparent
	StateManager.connect("respawned", self, "on_respawn")
	
func on_respawn():
	StateManager.disconnect("respawned", self, "on_respawn")
	tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.5)
	tween.start()
