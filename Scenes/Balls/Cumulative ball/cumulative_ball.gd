extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

func collide_with_enemy(collider) -> void:
	collider.deal_fire_damage(damage_ball * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"])
	queue_free()
