extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

func collide_with_enemy(collider) -> void:
	hit_enemy_sound.pitch_scale = AudioManager.get_random_pitch()
	hit_enemy_sound.play()
	LevelManager.rocket_ball_damage(collider, damage_ball * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"], self.global_position, 1)
	collider.deal_damage(damage_ball * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"])
