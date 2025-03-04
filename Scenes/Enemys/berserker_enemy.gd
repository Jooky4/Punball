extends "res://Scenes/Enemys/defalt_enemy.gd"

func berserker_enemy() -> void:
	pass

func math_damage_player():
	player_damage = int(100 * (3 * (1 - (hp_enemy / max_hp_enemy))))
