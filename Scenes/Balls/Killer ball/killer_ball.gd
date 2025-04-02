extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/KillerBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	hit_enemy_sound.pitch_scale += AudioManager.get_random_pitch()
	hit_enemy_sound.play()
	var damage_ball_plus = 0
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball_plus = round(damage_ball * 0.05)
	if randf() <= 0.02 and !collider.has_method("boss"):
		collider.deal_damage(collider.hp_enemy, ElementsManager.color_elements["TECHNOLOGIES"], true)
	else:
		collider.deal_damage((damage_ball + damage_ball_plus) * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	LevelManager.heal_hp_plaer_from_technologies()
