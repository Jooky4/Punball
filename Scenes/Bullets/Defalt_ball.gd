extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var line_trail : Line2D = $Line2D

var speed : int = 1200
var direction_bullet : Vector2
var damage_ball = 100
var max_lenght_line = 12

func _ready():
	velocity = Vector2(speed, speed)
	sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 1000))

func _process(delta: float) -> void:
	line_trail.add_point(self.global_position)
	if line_trail.points.size() > max_lenght_line:
		line_trail.remove_point(0)

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

			sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(reflect * 1000))
			move_and_collide(reflect)
			if collider.has_method("enemy"):
				collider.deal_damage(damage_ball)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
