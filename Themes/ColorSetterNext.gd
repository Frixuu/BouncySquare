extends CanvasItem

func on_theme_changed(_curr_theme, next_theme):
	self.modulate = (next_theme as GameTheme).boundary_color
