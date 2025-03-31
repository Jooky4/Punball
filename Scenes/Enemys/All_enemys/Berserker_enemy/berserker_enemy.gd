extends "res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.gd"

var start_damage

func _ready() -> void:
	max_hp_enemy = hp_enemy
	animation_enemy.play("Spawn")
	hp_enemy_bar.max_value = max_hp_enemy
	hp_enemy_bar.value = hp_enemy
	if hp_enemy>=10000:
		if int(hp_enemy) % 10000 == 0:
			hp_enemy_label.text = str(hp_enemy / 1000) + "K"
		elif int(hp_enemy) % 10000 != 0:
			hp_enemy_label.text = ("%.1f" % (hp_enemy / 1000)) + "K"
	else:
		hp_enemy_label.text = str(round(hp_enemy))
	start_damage = player_damage

func berserker_enemy() -> void:
	pass

func math_damage_player():
	player_damage = int(start_damage * (3 * (1 - (hp_enemy / max_hp_enemy))))
