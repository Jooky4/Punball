extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

func collide_with_enemy(collider) -> void:
	hit_enemy_sound.pitch_scale = AudioManager.get_random_pitch()
	hit_enemy_sound.play()
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball = round(damage_ball * 1.05)
	LevelManager.rocket_ball_damage(collider, damage_ball * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"], self.global_position, 1)
	collider.deal_damage(damage_ball * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"])
