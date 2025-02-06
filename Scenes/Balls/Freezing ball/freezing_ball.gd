extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"


var chance_of_freezing : float = 0.5

func collide_with_enemy(collider) -> void:
	#if randf() < chance_of_freezing:
	collider.deal_freezing_damage(damage_ball * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"])
