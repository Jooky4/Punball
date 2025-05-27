extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/FreezeBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	play_sound("hit_enemy")
	var damage_ball_plus = 0
	collider.deal_ball_character_2_damage(damage_ball * ElementsManager.normal_modifier, ElementsManager.color_elements["NORMAL"])
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
