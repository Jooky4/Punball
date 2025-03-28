extends StaticBody2D

var move_on_this_wave : bool = false

func moving(direction_object) -> void:
	if direction_object != "":
		var tween = get_tree().create_tween()
		if direction_object == "forward":
			tween.tween_property($".", "position", Vector2(0, 103) + self.position, 0.5).set_trans(Tween.TRANS_QUAD)
		elif direction_object == "left":
			tween.tween_property($".", "position", Vector2(-103, 0) + self.position, 0.5).set_trans(Tween.TRANS_QUAD)
		elif direction_object == "right":
			tween.tween_property($".", "position", Vector2(103, 0) + self.position, 0.5).set_trans(Tween.TRANS_QUAD)

func bonus_ball() -> void:
	pass
