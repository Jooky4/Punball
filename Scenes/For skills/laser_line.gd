extends Sprite2D

func show_line(rotate):
	if rotate == 1:
		create_tween().tween_property(self, "scale", Vector2(1.25, 1), 0.145)
		self.rotation_degrees = 90
	elif rotate == 0:
		create_tween().tween_property(self, "scale", Vector2(1, 1), 0.145)
	await get_tree().create_timer(0.18).timeout
	queue_free()
