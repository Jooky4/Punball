extends Sprite2D

func show_line(rotate):
	if rotate == 1:
		var tween = create_tween().tween_property(self, "scale", Vector2(1.25, 0.75), 0.14)
		tween.set_trans(Tween.TRANS_SINE) #  Тип перехода (синусоидальный - хороший выбор для плавного)
		tween.set_ease(Tween.EASE_IN_OUT) #  Плавность (ускорение в начале, замедление в конце)
		self.rotation_degrees = 90
	elif rotate == 0:
		var tween = create_tween().tween_property(self, "scale", Vector2(1, 0.75), 0.14)
		tween.set_trans(Tween.TRANS_SINE) # Тип перехода
		tween.set_ease(Tween.EASE_IN_OUT) # Плавность
	await get_tree().create_timer(0.2).timeout
	queue_free()
