extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

func collide_with_enemy(collider) -> void:
	collider.deal_freezing_damage(damage_ball * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"])
