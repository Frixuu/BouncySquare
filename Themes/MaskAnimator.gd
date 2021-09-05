extends Node2D

onready var tween: Tween = $Tween as Tween

func _ready():
	StateManager.connect("died", self, "on_player_died")
	StateManager.connect("respawned", self, "on_player_respawned")

func on_player_died():
	tween.stop(self)
	tween.interpolate_callback(self, 1.5, "start_enlarging")
	tween.start()
	
func start_enlarging():
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2(2.0, 2.0), 0.8)
	tween.start()
	
func on_player_respawned():
	tween.stop(self)
	self.scale = Vector2(0.0, 0.0)
