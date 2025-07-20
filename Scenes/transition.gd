extends CanvasLayer

@onready var fade_rect = $Fade

func fade_to_black(duration = 2):
	if not fade_rect:
		push_error("Fade node not found!")
		return null
	fade_rect.visible = true
	fade_rect.modulate.a = 0
	return fade_rect.create_tween().tween_property(fade_rect, "modulate:a", 1.0, duration)

func fade_from_black(duration = 2):
	if not fade_rect:
		push_error("Fade node not found!")
		return null
	fade_rect.visible = true
	fade_rect.modulate.a = 1
	var tween = fade_rect.create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	tween.finished.connect(func():
		fade_rect.visible = false
	)
	return tween
