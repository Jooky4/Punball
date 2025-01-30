extends StaticBody2D

func moving(direction_object) -> void:
	if direction_object != "":
		var tween = get_tree().create_tween()
		if direction_object == "forward":
			tween.tween_property($".", "position", Vector2(0, 103) + self.position, 1)
		elif direction_object == "left":
			tween.tween_property($".", "position", Vector2(-103, 0) + self.position, 1)
		elif direction_object == "right":
			tween.tween_property($".", "position", Vector2(103, 0) + self.position, 1)

func bonus_ball() -> void:
	pass
