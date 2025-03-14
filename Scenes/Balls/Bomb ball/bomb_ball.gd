extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/BombBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	AudioManager.bomb_ball_hit_sound()
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball = round(damage_ball * 1.05)
	LevelManager.ball_explosion(collider, damage_ball * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	queue_free()
