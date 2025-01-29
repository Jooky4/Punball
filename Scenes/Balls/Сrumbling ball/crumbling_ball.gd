extends CharacterBody2D

var SMALL_CRUMBLING_BALL = preload("res://Scenes/Balls/Сrumbling ball/small_crumbling_ball.tscn")
@onready var sprite = $CollisionShape2D
@onready var line_trail : Line2D = $Line2D

var speed : int = 1500
var direction_bullet : Vector2
var damage_ball = 100
var max_lenght_line = 8
var angle_rotation_small_ball : float = 0.2

func _ready():
	velocity = Vector2(speed, speed)
	sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))

func _physics_process(delta) -> void:
	line_trail.add_point(self.global_position)
	if line_trail.points.size() > max_lenght_line:
		line_trail.remove_point(0)

	var collision = move_and_collide(direction_bullet * velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("bonus_ball"):
			LevelManager.add_ball()
			collider.queue_free()
		else:
			direction_bullet = direction_bullet.bounce(collision.get_normal()).normalized()
			sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))
			if collider.has_method("enemy"):
				for i in range(-2, 3):
					if i != 0:
						var slall_crunbling_ball = SMALL_CRUMBLING_BALL.instantiate()
						slall_crunbling_ball.direction_bullet = Vector2.from_angle((rad_to_deg(direction_bullet.angle())) + (angle_rotation_small_ball * i))
						slall_crunbling_ball.global_position = self.global_position
						get_tree().current_scene.add_child(slall_crunbling_ball)
				collider.deal_damage(damage_ball)
				queue_free()
			move_and_collide(direction_bullet * velocity * delta)
