extends Node

var current_location = 1
var percent_cells_by_enemies = [10, 25, 70, 85, 95]
var dop_hp_defolt_enemy = [[2, 4, 1],
						   [5, 10, 2],
						   [11, 14, 3],
						   [14, 17, 4],
						   [18, 10000, 5]]
var count_wave_on_locations = {
	1: 20,
	2: 20,
	3: 30,
	4: 20,
	5: 40,
	6: 20,
	7: 20,
	8: 30,
	9: 20,
	10: 40
}
var based_enemy_hp_on_locations = {
	1: 400,
	2: 600,
	3: 800,
	4: 1200,
	5: 2000,
	6: 3000,
	7: 4000,
	8: 5000,
	9: 6000,
	10: 7000
}
var based_сlose_enemy_damage_player_on_locations = {
	1: 100,
	2: 140,
	3: 220,
	4: 300,
	5: 420,
	6: 540,
	7: 700,
	8: 860,
	9: 1060,
	10: 1260
}
var based_distant_enemy_damage_player_on_locations = {
	1: 20,
	2: 30,
	3: 50,
	4: 70,
	5: 100,
	6: 130,
	7: 170,
	8: 210,
	9: 260,
	10: 310
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
	if number_wave == count_wave_on_locations[current_location]:
		finish_array = [4,null,null,null,null,null]
		finish_array.shuffle()
		return finish_array
	elif number_wave == count_wave_on_locations[current_location] - 1:
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
	for i in enemy_for_locations[current_location - 1]:
		if i != 0:
			enemy_who_can_spawn.append(i)

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
	if number_wave > count_wave_on_locations[current_location]:
		number_wave = count_wave_on_locations[current_location]
	var hp_enemy = based_enemy_hp_on_locations[current_location]
	for i in range(1, number_wave + 1):
		for j in dop_hp_defolt_enemy:
			if j[0] <= i and i <= j[1]:
				hp_enemy += ((based_enemy_hp_on_locations[current_location] / 2) * j[2])
	return float(hp_enemy)

func how_many_damage_player(num_enemy) -> int:
	if num_enemy == 2 or num_enemy == 14:
		return based_distant_enemy_damage_player_on_locations[current_location]
	else:
		return based_сlose_enemy_damage_player_on_locations[current_location]

func get_count_wave_on_location() -> float:
	return count_wave_on_locations[current_location]

func get_coef_hp_enemy_when_boss_on_map():
	match count_wave_on_locations[current_location]:
		20:
			return 1.6
		30:
			return 1.2
		40:
			return 1.1
