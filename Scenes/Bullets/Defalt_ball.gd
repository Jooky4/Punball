extends CharacterBody2D

var speed : int = 1200
var direction_bullet : Vector2
var damage_ball = 100
@onready var sprite = $Sprite2D

func _ready():
	velocity = Vector2(speed, speed)
	sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 1000))

func _physics_process(delta) -> void:
	var collision: KinematicCollision2D = move_and_collide(direction_bullet * velocity * delta)
	if collision:
		var collider = collision.get_collider()

		if "Bonus_ball" in collider.name or collider.has_method("bonus_ball"):
			LevelManager.add_ball()
			collider.queue_free()
		else:
			var reflect = collision.get_remainder().bounce(collision.get_normal())
			velocity = velocity.bounce(collision.get_normal())
			velocity.x = speed if velocity.x > 0 else -speed
			velocity.y = speed if velocity.y > 0 else -speed

			if collider.has_method("enemy"):
				collider.deal_damage(damage_ball)
			sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(reflect * 1000))
			move_and_collide(reflect)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
