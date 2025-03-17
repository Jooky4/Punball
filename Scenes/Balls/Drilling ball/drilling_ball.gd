extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/DrillingBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	if body.has_method("enemy"):
		hit_enemy_sound.pitch_scale += AudioManager.get_random_pitch()
		hit_enemy_sound.play()
		var damage_ball_plus = 0
		if "Усиление особого шара" in LevelManager.player_skills:
			damage_ball_plus = round(damage_ball * 0.05)
		body.deal_damage((damage_ball + damage_ball_plus) * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	LevelManager.heal_hp_plaer_from_technologies()

func return_to_player(pos_player) -> void:
	$CollisionShape2D/Area2D.collision_mask = 0
	direction_bullet = Vector2.DOWN
	speed = 0
	sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(pos_player * 10000))
	create_tween().tween_property(self, "global_position", pos_player, 0.5)
