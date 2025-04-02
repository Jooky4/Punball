extends Node

var current_location = 1
var percent_cells_by_enemies = [10, 20, 70, 90, 100]
var dop_hp_defolt_enemy = [[2, 4, 1],
						   [5, 10, 2],
						   [11, 14, 3],
						   [15, 18, 4],
						   [19, 100, 5]]
var count_wave_on_locations = {
	0: 20,
	1: 20,
	2: 30,
	3: 20,
	4: 40,
	5: 20,
	6: 20,
	7: 30,
	8: 20,
	-1: 40
}

var enemy_for_locations = [[1, 2, 3, null], 
						   [1, 2, 6, null],
						   [1, 2, 5, 8],
						   [1, 2, 3, 9],
						   [1, 2, 10, 12],
						   [1, 2, 14, null],
						   [1, 2, 6, 8],
						   [1, 2, 12, 13],
						   [1, 2, 5, 9],
						   [1, 2, 3, 10]]

func generetion_new_wave(number_wave):
	var finish_array = [null,null,null,null,null,null]
	if number_wave == count_wave_on_locations[(current_location % 10) - 1]:
		if ((current_location % 10) - 1) == 0 or ((current_location % 10) - 1) == 1:
			finish_array = [null,null,4,null,null,null]
		elif ((current_location % 10) - 1) == 2 or ((current_location % 10) - 1) == 3:
			finish_array = [null,null,15,null,null,null]
		elif ((current_location % 10) - 1) == 4 or ((current_location % 10) - 1) == 5:
			finish_array = [null,null,18,null,null,null]
		elif ((current_location % 10) - 1) == 6 or ((current_location % 10) - 1) == 7:
			finish_array = [null,null,17,null,null,null]
		elif ((current_location % 10) - 1) == 8 or ((current_location % 10) - 1) == -1:
			finish_array = [null,null,16,null,null,null]
		return finish_array
	elif number_wave == count_wave_on_locations[(current_location % 10) - 1] - 1:
		return finish_array

	var coun_cell_with_enemy = 5
	if number_wave >= 2 and number_wave % 2 == 0:
		finish_array[0] = -1
		coun_cell_with_enemy -= 1
	if number_wave >= 3 and number_wave % 2 == 1:
		finish_array[0] = -2
		coun_cell_with_enemy -= 1

	var coun_cell_for_enemy = 0
	for i in range(percent_cells_by_enemies.size()):
		while coun_cell_for_enemy == 0:
			var random_index = randi() % percent_cells_by_enemies.size()
			if percent_cells_by_enemies[random_index] > (randi() % 100 + 1) and random_index + 1 <= coun_cell_with_enemy:
				coun_cell_for_enemy = random_index + 1
				break

	var enemy_who_can_spawn = []
	for i in range(enemy_for_locations[(current_location % 10) - 1].size()):
		if enemy_for_locations[(current_location % 10) - 1][i] != null:
			if i == 0 or i == 1:
				enemy_who_can_spawn.append(enemy_for_locations[(current_location % 10) - 1][i])
			elif i == 2 and number_wave >= 6:
				enemy_who_can_spawn.append(enemy_for_locations[(current_location % 10) - 1][i])
			elif i == 3 and number_wave >= 11:
				enemy_who_can_spawn.append(enemy_for_locations[(current_location % 10) - 1][i])
	var new_enemy_array = []
	for i in range(coun_cell_for_enemy):
		new_enemy_array.append(enemy_who_can_spawn[randi() % enemy_who_can_spawn.size()])
	new_enemy_array.shuffle()
	for i in range(new_enemy_array.size()):
		var inserted = false
		while not inserted:
			var random_index = randi() % finish_array.size()
			if finish_array[random_index] == null:
				finish_array[random_index] = new_enemy_array[i]
				inserted = true
	finish_array.shuffle()
	return finish_array

func how_many_hp_plus_enemy(number_wave) -> float:
	number_wave += 1
	if number_wave > count_wave_on_locations[(current_location % 10) - 1]:
		number_wave = count_wave_on_locations[(current_location % 10) - 1]
	var hp_enemy = 400
	var step = 0
	var start_plus_hp = 0
	for i in range(1, current_location + 1):
		if i % 2 == 0:
			step += 200
		start_plus_hp += step
	hp_enemy += start_plus_hp
	var start_hp_enemy = hp_enemy
	var count_wave : int = 2
	for j in dop_hp_defolt_enemy:
		for k in range((j[1] - j[0]) + 1):
			if j[0] <= count_wave and count_wave <= j[1] and count_wave <= number_wave:
				hp_enemy += (start_hp_enemy / 2) * j[2]
			count_wave += 1
	return float(hp_enemy)

func how_many_damage_player(num_enemy) -> int:
	var enemy_damage = 100
	var step = 0
	var start_plus_damage = 0
	for i in range(1, current_location + 1):
		if i % 2 == 0:
			step += 50
		start_plus_damage += step
	enemy_damage += start_plus_damage
	if num_enemy == 2 or num_enemy == 14:
		return round(enemy_damage / 5)
	else:
		return enemy_damage

func get_count_wave_on_location() -> float:
	return count_wave_on_locations[(current_location % 10) - 1]

func get_coef_hp_enemy_when_boss_on_map():
	match count_wave_on_locations[(current_location % 10) - 1]:
		20:
			return 1.6
		30:
			return 1.2
		40:
			return 1.1
