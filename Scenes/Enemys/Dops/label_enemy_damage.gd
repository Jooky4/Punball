extends Label

func _show_label(dop_x_pos : int = 0) -> void:
	self.visible = true
	var tween = get_tree().create_tween()
	if dop_x_pos:
		tween.tween_property(self, "position", Vector2(self.position.x + randi_range(-50, 50+dop_x_pos), self.position.y - randi_range(60, 75)), 0.3)
	else:
		tween.tween_property(self, "position", Vector2(self.position.x + randi_range(-50, 50), self.position.y - randi_range(60, 75)), 0.3)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "scale", Vector2(0.8, 0.8), 0.4)
	await get_tree().create_timer(0.5).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "modulate:a", 0, 0.35)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "position", Vector2(self.position.x, self.position.y + 25) , 0.5)
	tween3.tween_callback(_return_to_pool)


func show_label2(dop_x_pos : int = 0) -> void:
	_show_label(dop_x_pos)


func _return_to_pool() -> void:
	ObjectPool.return_object("enemy_damage_label", self)
