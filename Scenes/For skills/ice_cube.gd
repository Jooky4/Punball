extends Node2D

func ice_cube_go(enemy):
	self.global_position = Vector2(enemy.global_position.x, -200)
	create_tween().tween_property(self, "global_position", enemy.global_position, 0.5)
	await get_tree().create_timer(0.5).timeout
	if enemy != null:
		if enemy.alive:
			enemy.deal_freezing_damage(200 * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"])
	queue_free()
