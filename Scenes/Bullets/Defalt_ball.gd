extends CharacterBody2D

@onready var sprite = $CollisionShape2D
@onready var line_trail : Line2D = $Line2D

var speed : int = 1500
var direction_bullet : Vector2  =Vector2.UP
var damage_ball = 100
var max_lenght_line = 15

func _ready():
	velocity = Vector2(speed, speed)
	sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))

func _process(delta: float) -> void:
	line_trail.add_point(self.global_position)
	if line_trail.points.size() > max_lenght_line:
		line_trail.remove_point(0)

func _physics_process(delta) -> void:
	var collision = move_and_collide(direction_bullet * velocity * delta)
	if collision:
		var collider = collision.get_collider()

		if "Bonus_ball" in collider.name or collider.has_method("bonus_ball"):
			LevelManager.add_ball()
			collider.queue_free()
		else:
			direction_bullet = direction_bullet.bounce(collision.get_normal()).normalized()
			sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))
			move_and_collide(direction_bullet * velocity * delta)

			if collider.has_method("enemy"):
				collider.deal_damage(damage_ball)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
