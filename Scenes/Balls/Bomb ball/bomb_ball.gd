extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"


func collide_with_enemy(collider) -> void:
	LevelManager.bomb_ball_explosion(collider, damage_ball * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])
	queue_free()
