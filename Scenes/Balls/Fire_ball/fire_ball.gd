extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"


func collide_with_enemy(collider) -> void:
	collider.deal_fire_damage(damage_ball * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])

func combo_go(enemy):
	collision_mask = 0
	direction_bullet = Vector2.DOWN
	speed = 0	
	self.global_position = Vector2(enemy.global_position.x, -700)
	create_tween().tween_property(self, "global_position", enemy.global_position, 1)
	await get_tree().create_timer(1).timeout
	if enemy != null:
		if enemy.alive:
			enemy.deal_fire_damage(damage_ball * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])
	queue_free()
