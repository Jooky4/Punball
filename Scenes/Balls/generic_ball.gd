class_name GenericBall extends CharacterBody2D

@export var damage_ball : float = 200

@onready var sprite = $CollisionShape2D
@onready var AM = AudioManager


var hit_enemy_sound_name: String = "hit_enemy"
var ricochet_sound_name: String = "ricochet"

var speed : int = 1250
var direction_bullet : Vector2


func _ready():
	velocity = Vector2(speed, speed)

	if sprite:
		sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction_bullet * velocity * delta)

	if collision:
		var collider = collision.get_collider()

		if collider.has_method("bonus_ball"):
			LevelManager.add_ball(1)
			if randf() <= PlayerIndicatorsManager.FOR_CRYSTAL_SHANSE_DOP_BALL:
				LevelManager.add_ball(1)
			collider.queue_free()
			return
		elif collider.has_method("skill_box"):
			LevelManager.spin_skill += 1
			collider.queue_free()
			return
		else:
			direction_bullet = direction_bullet.bounce(collision.get_normal()).normalized()
			sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))

			if collider.has_method("enemy"):
				LevelManager.update_combo_count(collider)
				collide_with_enemy(collider)
			elif "Wall" in collider.name:
				play_sound(ricochet_sound_name)

			move_and_collide(direction_bullet * velocity * delta)


func collide_with_enemy(collider) -> void:
	play_sound(hit_enemy_sound_name)
	collider.deal_damage(damage_ball * ElementsManager.normal_modifier, ElementsManager.color_elements["NORMAL"])


func return_to_player(pos_player) -> void:
	collision_mask = 0
	direction_bullet = Vector2(pos_player - self.global_position).normalized()
	speed = 0
	sprite.rotation_degrees = 90 + rad_to_deg(sprite.position.angle_to_point(direction_bullet * 10000))
	create_tween().tween_property(self, "global_position", pos_player, 0.3)


func play_sound(sound_name: String) -> void:
	AM.play_sound(sound_name)


func ball() -> void:
	pass
