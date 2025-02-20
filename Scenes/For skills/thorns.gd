extends Node2D

func damage_enemy(enemy) -> void:
	if enemy.has_method("boss"):
		self.scale = Vector2(2, 2)
		self.global_position += Vector2(40, 50)
	enemy.deal_damage(600 * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	$AnimationPlayer.play("Spawn")
	await get_tree().create_timer(0.5).timeout
	queue_free()
