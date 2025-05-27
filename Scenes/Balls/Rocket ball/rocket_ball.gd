extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

func collide_with_enemy(collider) -> void:
	var damage_ball_plus = 0
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball_plus = round(damage_ball * 0.05)
	LevelManager.rocket_ball_damage(collider, (damage_ball + damage_ball_plus) * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"], self.global_position, 1)
	collider.deal_damage((damage_ball + damage_ball_plus) * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"])
