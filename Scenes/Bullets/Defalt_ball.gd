extends CharacterBody2D

var speed : int = 1200
var direction_bullet : Vector2

func _ready():
	velocity = Vector2(speed, speed)

func _physics_process(delta) -> void:
	var collision: KinematicCollision2D = move_and_collide(direction_bullet * velocity * delta)
	if collision:
		var collider = collision.get_collider()

		if "Bonus_ball" in collider.name:
			LevelManager.add_ball()
			collider.queue_free()
		else:
			var reflect = collision.get_remainder().bounce(collision.get_normal())
			velocity = velocity.bounce(collision.get_normal())
			velocity.x = speed if velocity.x > 0 else -speed
			velocity.y = speed if velocity.y > 0 else -speed

			if collider.has_method("enemy"):
				collider.deal_damage()

			move_and_collide(reflect)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
