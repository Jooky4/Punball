extends "res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.gd"

@export var ENEMY_BULLET : PackedScene = preload("res://Scenes/Enemys/Dops/blueberries_bullet.tscn")
@export var bullet_damage = 20

func shoot_at_player(player_position) -> void:
	if alive and !freezen:
		play_animation_hit_player()
		await get_tree().create_timer(0.25).timeout
		var buff = ENEMY_BULLET.instantiate()
		buff.position += get_bullet_pos()
		self.add_child(buff)
		var tween = get_tree().create_tween()
		tween.tween_property(buff, "global_position", player_position, 0.5)
		await get_tree().create_timer(0.5).timeout
		LevelManager.damage_player(player_damage)
		buff.queue_free()

func get_bullet_pos() -> Vector2:
	return Vector2(25, 0)
