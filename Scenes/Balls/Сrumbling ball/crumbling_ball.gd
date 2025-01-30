extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var SMALL_CRUMBLING_BALL = preload("res://Scenes/Balls/Сrumbling ball/small_crumbling_ball.tscn")
var angle_rotation_small_ball : float = 0.2

func collide_with_enemy(collider) -> void:
	for i in range(-2, 3):
		if i != 0:
			var slall_crunbling_ball = SMALL_CRUMBLING_BALL.instantiate()
			slall_crunbling_ball.direction_bullet = Vector2.from_angle((rad_to_deg(direction_bullet.angle())) + (angle_rotation_small_ball * i))
			slall_crunbling_ball.global_position = self.global_position
			get_tree().current_scene.add_child(slall_crunbling_ball)
	collider.deal_damage(damage_ball)
	queue_free()
