extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"


func collide_with_enemy(collider) -> void:
	var position_enemy = collider.get_global_position()
	var self_position = self.get_global_position()
	var delta_x = position_enemy.x - self_position.x
	var delta_y = position_enemy.y - self_position.y 
	if abs(delta_x) > abs(delta_y):
		if delta_x > 0:
			collider.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
		else:
			collider.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	else:
		if delta_y > 0:
			collider.deal_damage(1000 * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
		else:
			collider.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
