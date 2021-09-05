extends Node

export (Array, Resource) var available_themes
export var current_theme: Resource
export var next_theme: Resource

signal theme_changed(new_theme, next_theme)

func _ready():
	StateManager.connect("respawned", self, "choose_next_theme")
	var index = randi() % available_themes.size()
	current_theme = available_themes[index]
	next_theme = current_theme
	emit_signal("theme_changed", current_theme, next_theme)

func choose_next_theme():
	current_theme = next_theme
	var candidates = available_themes.duplicate(false)
	candidates.erase(current_theme)
	next_theme = candidates[randi() % candidates.size()]
	emit_signal("theme_changed", current_theme, next_theme)
