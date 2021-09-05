extends Sprite

func on_theme_changed(_current_theme, next_theme):
	self.texture = (next_theme as GameTheme).background_image
