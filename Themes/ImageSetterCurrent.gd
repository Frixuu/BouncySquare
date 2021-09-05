extends Sprite

func on_theme_changed(current_theme, _next_theme):
	self.texture = (current_theme as GameTheme).background_image
