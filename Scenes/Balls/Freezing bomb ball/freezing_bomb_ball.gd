extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"


var chance_of_freezing : float = 0.1

func collide_with_enemy(collider) -> void:
	LevelManager.ball_explosion(collider, damage_ball * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"], chance_of_freezing)
	queue_free()
