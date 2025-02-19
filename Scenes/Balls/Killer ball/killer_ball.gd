extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

func collide_with_enemy(collider) -> void:
	if !collider.has_method("boss"):
		if randf() < 0.02:
			collider.deal_damage(collider.hp_enemy, ElementsManager.color_elements["TECHNOLOGIES"], true)
		else:
			collider.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
