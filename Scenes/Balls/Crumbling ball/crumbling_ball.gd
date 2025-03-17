extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var SMALL_CRUMBLING_BALL = preload("res://Scenes/Balls/Crumbling ball/small_crumbling_ball.tscn")
var EFFECT_BALL = preload("res://Scenes/Effects/CrumblingBallExplosion.tscn")
var angle_rotation_small_ball : int = 15

func collide_with_enemy(collider) -> void:
	hit_enemy_sound.pitch_scale += AudioManager.get_random_pitch()
	hit_enemy_sound.play()
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	for i in range(-2, 3):
		if i != 0:
			var slall_crunbling_ball = SMALL_CRUMBLING_BALL.instantiate()
			slall_crunbling_ball.direction_bullet = Vector2.from_angle((rad_to_deg(direction_bullet.angle())) + (angle_rotation_small_ball * i))
			slall_crunbling_ball.global_position = self.global_position
			get_tree().current_scene.add_child(slall_crunbling_ball)
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball = round(damage_ball * 1.05)
	collider.deal_damage(damage_ball * ElementsManager.laser_modifier, ElementsManager.color_elements["LASER"])
	queue_free()
