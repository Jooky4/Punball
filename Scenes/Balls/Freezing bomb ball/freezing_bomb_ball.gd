extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/FreezeBombBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	hit_enemy_sound.pitch_scale = AudioManager.get_random_pitch()
	hit_enemy_sound.play()
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball = round(damage_ball * 1.05)
	LevelManager.ball_explosion(collider, damage_ball * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"])
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	self.visible = false
	collision_mask = 0
	direction_bullet = Vector2(0, 0)
	speed = 0

func _on_hit_enemy_sound_finished() -> void:
	queue_free()
