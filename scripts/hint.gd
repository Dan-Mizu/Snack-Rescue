extends RichTextLabel

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "theme_override_font_sizes/normal_font_size", 5, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).from_current().as_relative()
	tween.tween_property(self, "theme_override_font_sizes/normal_font_size", -5, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).as_relative()
