extends Node

var percent_cells_by_enemies = [[[1, 6], 10, 20, 60, 10, null],
								[[7, 10], null, null, 20, 40, 40],
								[[11, 15], 10, 20, 60, 10, null],
								[[16, 20], null, null, 20, 40, 40]]
var dop_hp_defolt_enemy = [[2, 4, 200],
						   [5, 10, 400],
						   [11, 14, 600],
						   [11, 14, 200],
						   [14, 20, 800]]
var percent_spawn_enemy = [[1, 1, 40],
						   [2, 6, 30],
						   [3, 11, 30],]

func generetion_new_wave(number_wave):
	var coun_cell_with_enemy = 0
	for i in range(percent_cells_by_enemies.size()):
		if percent_cells_by_enemies[i][0][0] <= number_wave and number_wave <= percent_cells_by_enemies[i][0][1]:
			while coun_cell_with_enemy == 0:
				for j in range(1, percent_cells_by_enemies[i].size()):
					if percent_cells_by_enemies[i][j] != null:
						if percent_cells_by_enemies[i][j] > randi() % 100 + 1:
							coun_cell_with_enemy = j
							break
	print(coun_cell_with_enemy)
	var enemy_who_can_spawn = []
	var all_percent = 0
	for i in range(percent_spawn_enemy.size()):
		if percent_spawn_enemy[i][1] <= number_wave:
			enemy_who_can_spawn.append([percent_spawn_enemy[i][0], percent_spawn_enemy[i][2]])
			all_percent += percent_spawn_enemy[i][2]
	print(enemy_who_can_spawn)
	print(all_percent)
	var new_enemy_array = []
	for i in range(coun_cell_with_enemy):
		var new_enemy = null
		while new_enemy == null:
			for j in enemy_who_can_spawn:
				if j[1] > randi() % 100 + 1:
					new_enemy = j[0]
					new_enemy_array.append(j[0])
					break
	print(new_enemy_array)
	new_enemy_array.shuffle()
	var finish_array = [null,null,null,null,null,null]
	for i in range(new_enemy_array.size()):
		var inserted = false
		while not inserted:
			var random_index = randi() % finish_array.size()
			if finish_array[random_index] == null:
				finish_array[random_index] = new_enemy_array[i]
				inserted = true
	print(number_wave)
	print(finish_array)
	return finish_array

func how_many_hp_plus_enemy(number_wave) -> int:
	for i in dop_hp_defolt_enemy:
		if i[0] <= number_wave and number_wave <= i[1]:
			return i[2]
	return 0
