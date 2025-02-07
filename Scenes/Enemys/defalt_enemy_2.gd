extends "res://Scenes/Enemys/defalt_enemy.gd"

var ENEMY_BULLET = preload("res://Scenes/Enemys/enemy_bullet.tscn")
@export var bullet_damage = 20

func shoot_at_player(player_position) -> void:
	if alive:
		var buff = ENEMY_BULLET.instantiate()
		self.add_child(buff)
		var tween = get_tree().create_tween()
		tween.tween_property(buff, "global_position", player_position, 0.5)
		await get_tree().create_timer(0.5).timeout
		LevelManager.damage_player(bullet_damage)
		buff.queue_free()
