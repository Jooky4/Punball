extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var line_damage

func collide_with_enemy(collider) -> void:
	AM.play_sound("hit_enemy_laserball")
	var damage_ball_plus = 0
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball_plus = round(damage_ball * 0.05)
	LevelManager.laser_ball_damage(collider, (damage_ball + damage_ball_plus) * ElementsManager.laser_modifier, ElementsManager.color_elements["LASER"], line_damage)
