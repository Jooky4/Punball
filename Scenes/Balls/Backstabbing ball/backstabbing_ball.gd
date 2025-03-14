extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/BackstabbingBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	hit_enemy_sound.pitch_scale = AudioManager.get_random_pitch()
	hit_enemy_sound.play()
	var position_enemy = collider.get_global_position()
	var self_position = self.get_global_position()
	var delta_x = position_enemy.x - self_position.x
	var delta_y = position_enemy.y - self_position.y 
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball = round(damage_ball * 1.05)
	if abs(delta_x) > abs(delta_y):
		if delta_x > 0:
			collider.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
		else:
			collider.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	else:
		if delta_y > 0:
			collider.deal_damage(1000 * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
		else:
			collider.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	LevelManager.heal_hp_plaer_from_technologies()
