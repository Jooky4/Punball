extends "res://Scenes/Enemys/defalt_enemy.gd"

func medic() -> void:
	pass

func heal_enemy() -> void:
	var max_hp = 10000000
	var enemy_for_heal = null
	for i in LevelManager.first_level_links_on_objects:
		for j in i:
			if j != null:
				if j.has_method("enemy") and j.alive:
					if (j.max_hp_enemy > j.hp_enemy) and (max_hp > j.hp_enemy):
						enemy_for_heal = j
	if enemy_for_heal != null:
		enemy_for_heal.heal_hp(self.max_hp_enemy * 0.5)
		animation_enemy.play("Hill")
