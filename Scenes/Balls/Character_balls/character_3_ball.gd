extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var SMALL_BALL = preload("res://Scenes/Balls/Character_balls/character_3_ball.tscn")
var EFFECT_BALL = preload("res://Scenes/Effects/CrumblingBallExplosion.tscn")
var angle_rotation_small_ball : int = 15


func _ready() -> void:
	super()
	hit_enemy_sound_name = "hit_enemy_char3ball"


func collide_with_enemy(collider) -> void:
	AM.play_sound("hit_enemy_char3ball")
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	collider.deal_damage(damage_ball * ElementsManager.normal_modifier, ElementsManager.color_elements["NORMAL"])
	if randf() <= 0.01:
		for i in range(-1, 2):
			if i != 0:
				var slall_ball = SMALL_BALL.instantiate()
				slall_ball.direction_bullet = Vector2.from_angle((rad_to_deg(direction_bullet.angle())) + (angle_rotation_small_ball * i))
				slall_ball.global_position = self.global_position
				get_tree().current_scene.add_child(slall_ball)
		queue_free()
