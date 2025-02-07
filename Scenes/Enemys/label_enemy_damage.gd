extends Label

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(self.position.x + randi_range(-50, 50), self.position.y - randi_range(60, 75)), 0.3)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "scale", Vector2(0.8, 0.8), 0.4)
	await get_tree().create_timer(0.5).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "modulate:a", 0, 0.35)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "position", Vector2(self.position.x, self.position.y + 25) , 0.5)
	await get_tree().create_timer(0.35).timeout
	self.queue_free()
