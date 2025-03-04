extends "res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.gd"

var SMALL_SLIME_SPAWN = preload("res://Scenes/Enemys/Dops/small_slime_spawn.tscn")
var SMALL_SLIME = preload("res://Scenes/Enemys/All_enemys/Slime_small_enemy/slime_small_enemy.tscn")

func die() -> void:
	var free_spot : Array = []
	var pos_enemy : Vector2 = Vector2(-1, -1)
	var count_pos_self_enemy : int
	for i in range(LevelManager.first_level_links_on_objects.size()):
		for j in range(LevelManager.first_level_links_on_objects[i].size()):
			if LevelManager.first_level_links_on_objects[i][j] == self:
				pos_enemy = Vector2(i, j)
				count_pos_self_enemy = int((pos_enemy.x * 6) + (pos_enemy.y + 1)) - 1 
				break

	free_spot = LevelManager.find_all_free_spot()

	if free_spot == []:
		for i in range(LevelManager.first_level_links_on_objects[0].size()):
			if LevelManager.first_level_links_on_objects[0][i] == null:
				free_spot.append(Vector2(0, i))

	if free_spot != []:
		if free_spot.size() == 1:
			if get_tree().current_scene.has_method("spawn_objects_by_index"):
				var count_pos = int((free_spot[0].x * 6) + (free_spot[0].y + 1)) - 1 
				LevelManager.first_level_links_on_objects[count_pos/6][count_pos%6] = 7
				LevelManager.first_level_links_on_objects[count_pos_self_enemy/6][count_pos_self_enemy%6] = 7
				get_tree().get_current_scene().call("spawn_objects_by_index", count_pos)
				get_tree().get_current_scene().call("spawn_objects_by_index", count_pos_self_enemy)
				var end_pos = Vector2((free_spot[0] - pos_enemy) * Vector2(103, 103))
				var buff = SMALL_SLIME_SPAWN.instantiate()
				buff.global_position = self.global_position
				get_tree().current_scene.add_child(buff)
				buff.go(Vector2(end_pos.y, end_pos.x), count_pos)

				var buff1 = SMALL_SLIME_SPAWN.instantiate()
				buff1.global_position = self.global_position
				get_tree().current_scene.add_child(buff1)
				buff1.go(Vector2(0, 0), count_pos_self_enemy)

		elif free_spot.size() >= 2:
			for i in range(2):
				if get_tree().current_scene.has_method("spawn_objects_by_index"):
					var pos_small_slime = free_spot[randi() % free_spot.size()]
					var count_pos = int((pos_small_slime.x * 6) + (pos_small_slime.y + 1)) - 1 
					LevelManager.first_level_links_on_objects[count_pos/6][count_pos%6] = 7
					get_tree().get_current_scene().call("spawn_objects_by_index", count_pos)
					var buff = SMALL_SLIME_SPAWN.instantiate()
					var end_pos = Vector2((pos_small_slime - pos_enemy) * Vector2(103, 103))
					buff.global_position = self.global_position
					get_tree().current_scene.add_child(buff)
					buff.go(Vector2(end_pos.y, end_pos.x), count_pos)
					free_spot.erase(pos_small_slime)

	elif free_spot == []:
		if get_tree().current_scene.has_method("spawn_objects_by_index"):
			LevelManager.first_level_links_on_objects[count_pos_self_enemy/6][count_pos_self_enemy%6] = 7
			get_tree().get_current_scene().call("spawn_objects_by_index", count_pos_self_enemy)
			var buff = SMALL_SLIME_SPAWN.instantiate()
			buff.global_position = self.global_position
			get_tree().current_scene.add_child(buff)
			buff.go(Vector2(0, 0), count_pos_self_enemy)
