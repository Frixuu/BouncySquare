extends CanvasItem

func on_theme_changed(curr_theme, _next_theme):
	self.modulate = (curr_theme as GameTheme).boundary_color
