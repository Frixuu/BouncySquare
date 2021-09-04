extends Node

signal color_change(color, duration)

func change_color(color: Color):
	emit_signal("color_change", color, 0.0)

func change_color_smoothly(color: Color, duration: float):
	emit_signal("color_change", color, duration)
