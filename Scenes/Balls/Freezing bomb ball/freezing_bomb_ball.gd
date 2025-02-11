extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

func collide_with_enemy(collider) -> void:
	LevelManager.ball_explosion(collider, damage_ball * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"], 1)
	queue_free()
