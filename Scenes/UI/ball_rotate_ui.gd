extends CharacterBody2D


var speed : int = 100
var direction_bullet : Vector2
var stop = false
var collider_name

func _ready():
	velocity = Vector2(speed, speed)

func ball_go() -> void:
	var collision: KinematicCollision2D = move_and_collide(direction_bullet * velocity)
	if collision:
		collider_name = collision.get_collider().name
		stop = true
