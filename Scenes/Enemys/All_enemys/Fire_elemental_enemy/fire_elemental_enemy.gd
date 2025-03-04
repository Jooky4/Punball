extends "res://Scenes/Enemys/All_enemys/Blueberries_enemy/blueberries_enemy.gd"

func deal_fire_damage(damage_ball, color_label) -> void:
	if alive:
		create_label_damage("НЕУЯЗВИМОСТЬ", ElementsManager.color_elements["NORMAL"])

func deal_bomb_damage(damage_ball, color_label) -> void:
	if alive:
		create_label_damage("НЕУЯЗВИМОСТЬ", ElementsManager.color_elements["NORMAL"])

func deal_freezing_damage(damage_ball, color_label) -> void:
	if alive:
		deal_damage(damage_ball * 2, color_label)
		if randf() < LevelManager.chance_of_freezing:
			freezen = true
			freezen_sprite.visible = true
