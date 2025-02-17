extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var line_damage

func collide_with_enemy(collider) -> void:
	LevelManager.laser_ball_damage(collider, damage_ball * ElementsManager.laser_modifier, ElementsManager.color_elements["LASER"], line_damage)
