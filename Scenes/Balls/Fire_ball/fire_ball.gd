extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/FireBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	hit_enemy_sound.pitch_scale = AudioManager.get_random_pitch()
	hit_enemy_sound.play()
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball = round(damage_ball * 0.05)
	collider.deal_fire_damage(damage_ball * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)

func combo_go(enemy):
	collision_mask = 0
	direction_bullet = Vector2.DOWN
	speed = 0
	self.global_position = Vector2(enemy.global_position.x, -200)
	create_tween().tween_property(self, "global_position", enemy.global_position, 0.5)
	await get_tree().create_timer(0.5).timeout
	if enemy != null:
		if enemy.alive:
			enemy.deal_fire_damage(500 * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])
	queue_free()
