extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"


func collide_with_enemy(collider) -> void:
	collider.deal_damage(damage_ball * ElementsManager.lightning_modifier, ElementsManager.color_elements["LIGHTNING"])
	LevelManager.lighthing_ball_damage(collider, damage_ball * ElementsManager.lightning_modifier, ElementsManager.color_elements["LIGHTNING"])
