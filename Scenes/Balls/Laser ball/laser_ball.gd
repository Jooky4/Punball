extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var line_damage

func collide_with_enemy(collider) -> void:
	hit_enemy_sound.pitch_scale += AudioManager.get_random_pitch()
	hit_enemy_sound.play()
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball = round(damage_ball * 1.05)
	LevelManager.laser_ball_damage(collider, damage_ball * ElementsManager.laser_modifier, ElementsManager.color_elements["LASER"], line_damage)
