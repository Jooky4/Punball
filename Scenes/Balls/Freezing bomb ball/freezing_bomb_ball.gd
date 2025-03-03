extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/FreezeBombBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	LevelManager.ball_explosion(collider, damage_ball * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"])
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	queue_free()
