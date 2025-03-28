extends "res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.gd"

func _ready() -> void:
	max_hp_enemy = hp_enemy
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("SpawnMagic")
	hp_enemy_bar.max_value = max_hp_enemy
	hp_enemy_bar.value = hp_enemy
	if hp_enemy>=10000:
		if int(hp_enemy) % 10000 == 0:
			hp_enemy_label.text = str(hp_enemy / 1000) + "K"
		elif int(hp_enemy) % 10000 != 0:
			hp_enemy_label.text = ("%.1f" % (hp_enemy / 1000)) + "K"
	else:
		hp_enemy_label.text = str(round(hp_enemy))
	if !self.has_method("boss"):
		self.z_index = 2
	await get_tree().create_timer(0.7).timeout
	LevelManager.check_traps()
