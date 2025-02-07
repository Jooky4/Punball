extends Node

var hp_player : float = 1000
var max_hp_player : float = 1000
var player_balls : Array = [1, 1, 1, 1]
var player_balls_after_wave : Array = []
var count_level : int = 0
var count_experiance : int = 0
var combo_count : int = 0
var spin_skill : int = 0
var first_level_spawn : Array = [[null, null, 1, 1, -1, null],
								 [-1, 1, 1, 1, null, null],
								 [1, 1, 1, null, -1, 1],
								 [1, null, -1, 1, 1, null],
								 [-1, 1, 1, null, 1, null],
								 [1, null, -1, null, null, null],
								 [1, 1, null, 1, 1, null],
								 [1, 1, 1, 1, -1, 1],
								 [-1, 1, null, 1, null, null],
								 [null, 1, 1, 1, null, -1],
								 [1, 1, null, null, null, -1],
								 [null, 1, null, 1, 1, -1],
								 [null, 1, 1, 1, 1, -1],
								 [1, null, null, 1, null, -1],
								 [1, 1, null, -1, null, null],
								 [1, null, null, -1, 1, null],
								 [null, -1, 1, null, 1, 1],
								 [null, null, null, null, null, null],
								 [null, null, 1, 1, null, null],
								 [null, null, 1, 1, null, null]]
var first_level_links_on_objects : Array = [[null, null, null, null, null, null],
											[null, 2, 1, 1, 1, 2],
											[null, null, null, null, null, null],
											[2, 2, 2, 2, 1, null],
											[null, -2, null, null, null, null],
											[null, -2, null, null, null, null],
											[null, null, null, null, null, null],
											[null, null, null, null, null, null]]


func restert() -> void:
	hp_player = 1000
	max_hp_player = 1000
	count_level = 0
	spin_skill = 0
	combo_count = 0
	count_experiance = 0
	first_level_links_on_objects = [[null, null, null, null, null, null],
									[null, 1, 1, 1, 1, 1],
									[null, null, null, null, null, null],
									[1, 1, 1, 1, 1, null],
									[null, null, null, null, null, null],
									[null, null, null, null, null, null],
									[null, null, null, null, null, null],
									[null, null, null, null, null, null]]
	first_level_spawn = [[null, null, 1, 1, -1, null],
						 [-1, 1, 1, 1, null, null],
						 [1, 1, 1, null, -1, 1],
						 [1, null, -1, 1, 1, null],
						 [-1, 1, 1, null, 1, null],
						 [1, null, -1, null, null, null],
						 [1, 1, null, 1, 1, null],
						 [1, 1, 1, 1, -1, 1],
						 [-1, 1, null, 1, null, null],
						 [null, 1, 1, 1, null, -1],
						 [1, 1, null, null, null, -1],
						 [null, 1, null, 1, 1, -1],
						 [null, 1, 1, 1, 1, -1],
						 [1, null, null, 1, null, -1],
						 [1, 1, null, -1, null, null],
						 [1, null, null, -1, 1, null],
						 [null, -1, 1, null, 1, 1],
						 [null, null, null, null, null, null],
						 [null, null, 1, 1, null, null],
						 [null, null, 1, 1, null, null]]

func add_ball(num_ball) -> void:
	player_balls_after_wave.append(num_ball)

func damage_player(damage) -> void:
	hp_player -= damage

func apeend_new_balls() -> void:
	player_balls.append_array(player_balls_after_wave)
	player_balls_after_wave.clear()

func enemy_shoot(player_position) -> void:
	for i in first_level_links_on_objects:
		for j in i:
			if j != null:
				if j.has_method("shoot_at_player"):
					j.shoot_at_player(player_position)

func moving_object() -> void:
	for i in first_level_links_on_objects[7]: # НАНЕСЕНИЕ УРОНА ИГРОКУ
		if i != null:
			if i.has_method("enemy"):
				if !i.freezen:
					damage_player(i.player_damage)

	for i in range(first_level_links_on_objects[7].size()): # УДАЛЕНИЕ ОБЪЕКТОВ С ПОСЛЕДНЕЙ СТРОЧКИ
		if first_level_links_on_objects[7][i] != null:
			if first_level_links_on_objects[7][i].has_method("enemy"):
				if !first_level_links_on_objects[7][i].freezen:
					first_level_links_on_objects[7][i].queue_free()
					first_level_links_on_objects[7][i] = null
			else:
				first_level_links_on_objects[7][i].queue_free()
				first_level_links_on_objects[7][i] = null

	for i in range(first_level_links_on_objects.size() - 2, -1, -1):
		for w in range(first_level_links_on_objects[i].size()): # СНАЧАЛА ПРОДВИГАЕМ ВПЁРЕД ТЕХ У КОГО СПЕРЕДИ ПУСТО
			if first_level_links_on_objects[i][w] != null:
				if first_level_links_on_objects[i+1][w] == null:
					if first_level_links_on_objects[i][w].has_method("enemy"):
						if !first_level_links_on_objects[i][w].freezen:
							move_forward(i, w)
					else:
						move_forward(i, w)
		for j in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null:  # ПОТОМ ДВИГАЕМ ВПРАВО, ВЛЕВО ТЕХ У КОГО ПРЕПЯТСВИЕ СПЕРЕДИ
				if first_level_links_on_objects[i+1][j] != null:
					if first_level_links_on_objects[i+1][j].has_method("enemy"):
						if first_level_links_on_objects[i+1][j].freezen:
							if first_level_links_on_objects[i][j].has_method("enemy"):
								if !first_level_links_on_objects[i][j].freezen:
									move_left_or_right(i, j)
							else:
								move_left_or_right(i, j)

func move_forward(i, j) ->void:
	first_level_links_on_objects[i][j].moving("forward")
	first_level_links_on_objects[i+1][j] = first_level_links_on_objects[i][j]
	first_level_links_on_objects[i][j] = null

func move_left_or_right(i, j) ->void:
	if j != 0:
		if first_level_links_on_objects[i][j-1] == null:
			first_level_links_on_objects[i][j].moving("left")
			first_level_links_on_objects[i][j-1] = first_level_links_on_objects[i][j]
			first_level_links_on_objects[i][j] = null
		else:
			if j != 5:
				if first_level_links_on_objects[i][j+1] == null:
					first_level_links_on_objects[i][j].moving("right")
					first_level_links_on_objects[i][j+1] = first_level_links_on_objects[i][j]
					first_level_links_on_objects[i][j] = null
			else:
				print(i+1," ", j+1, ": ВСЁ ЗАНЯТО Я ТУТ ОСТАНУСЬ")

func updete_last_line() -> void:
	var new_line_spawn
	if count_level >= 19:
		new_line_spawn = [null, null, null, null, null, null]
	else:
		new_line_spawn = WaveGeneration.generetion_new_wave(count_level+1)
		#new_line_spawn = first_level_spawn[count_level]
		for i in range(new_line_spawn.size()):
			if new_line_spawn[i] != null:
				if first_level_links_on_objects[0][i] != null:
					if new_line_spawn.find(null) != -1:
						new_line_spawn[first_level_links_on_objects[0].find(null)] = new_line_spawn[i]
						new_line_spawn[i] = null
					else:
						print("ОШИБКА: НЕТ СВОБОДНОГО МЕСТА ДЛЯ НОВОГО ВРАГА")
 
	for i in range(new_line_spawn.size()):
		if new_line_spawn[i] != null:
			first_level_links_on_objects[0][i] = new_line_spawn[i]
	count_level += 1

func bomb_ball_explosion(enemy, damage_ball, color_ball) -> void:
	var x
	var y
	for i in range(first_level_links_on_objects.size()):
		for j in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null:
				if first_level_links_on_objects[i][j] == enemy:
					x = i
					y = j
					break
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var target_x = x + dx
			var target_y = y + dy
			if target_x >= 0 and target_x < 8 and target_y >= 0 and target_y < 6:
				if first_level_links_on_objects[target_x][target_y] != null:
					if first_level_links_on_objects[target_x][target_y].has_method("enemy"):
						first_level_links_on_objects[target_x][target_y].deal_bomb_damage(damage_ball, color_ball)
						combo_count += 1 # можно будет убрать

func delete_freezing_on_enemy() -> void:
	for i in first_level_links_on_objects:
		for j in i:
			if j != null:
				if j.has_method("enemy"):
					j.delete_freezing()

func update_combo_count():
	combo_count += 1
