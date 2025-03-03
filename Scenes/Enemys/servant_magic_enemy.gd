extends "res://Scenes/Enemys/defalt_enemy.gd"

func _ready() -> void:
	max_hp_enemy = hp_enemy
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("SpawnMagic")
	hp_enemy_bar.max_value = max_hp_enemy
	hp_enemy_bar.value = hp_enemy
	if hp_enemy>=10000:
		hp_enemy_label.text = str(hp_enemy/1000) + "K"
	else:
		hp_enemy_label.text = str(hp_enemy)
	if !self.has_method("boss"):
		self.z_index = 2
