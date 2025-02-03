extends CharacterBody2D

@onready var sprite = $CollisionShape2D
@onready var line_trail : Line2D = $Line2D

@export var damage_ball : int = 100
@export var max_lenght_line : int = 6
var speed : int = 1250
var direction_bullet : Vector2

func _ready():
	velocity = Vector2(speed, speed)
	sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))

func _physics_process(delta) -> void:
	line_trail.add_point(self.global_position + (direction_bullet * 14))
	if line_trail.points.size() > max_lenght_line:
		line_trail.remove_point(0)

	var collision = move_and_collide(direction_bullet * velocity * delta)
	if collision:
		var collider = collision.get_collider()

		if collider.has_method("bonus_ball"):
			LevelManager.add_ball()
			collider.queue_free()
		elif collider.has_method("skill_box"):
			LevelManager.spin_skill += 1
			collider.queue_free()
		else:
			direction_bullet = direction_bullet.bounce(collision.get_normal()).normalized()
			sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))

			if collider.has_method("enemy"):
				LevelManager.update_combo_count()
				collide_with_enemy(collider)

			move_and_collide(direction_bullet * velocity * delta)

func collide_with_enemy(collider) -> void:
	collider.deal_damage(damage_ball)
