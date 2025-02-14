extends Node

var line_lightning = preload("res://Scenes/Balls/Lightning ball/line_lightning.tscn")

var hp_player : float = 1000
var boss_on_map : bool = false
var max_hp_player : float = 1000
var player_balls : Array = [1, 1, 1, 1]
var player_balls_after_wave : Array = []
var count_level : int = 0
var count_experiance : int = 0
var combo_count : int = 0
var spin_skill : int = 0
var count_damage_lightning_enemy : int = 3
var chance_of_freezing : float = 0.4
var hit_player : bool = false
var player_skills : Array = []#["Повелитель огня", "Молния смерти", "Холод смерти", "Бомба смерти"]
var first_level_spawn : Array = [[null, null, 1, 1, -1, null],
								[-2, 1, 1, 1, null, null],
								[1, 1, 1, null, -1, 1],
								[1, null, -2, 1, 1, null],
								[-1, 1, 1, null, 1, null],
								[1, null, -2, null, null, null],
								[1, 1, null, 1, 1, null],
								[1, 2, 2, 1, -2, 1],
								[-1, 1, null, 1, null, null],
								[null, 1, 3, 3, null, -2],
								[2, 1, null, null, null, -1] ,
								[null, 1, null, 1, 3, -2],
								[null, 1, 1, 2, 2, -1],
								[2, null, null, 2, null, -2],
								[2, 1, null, -1, null, null],
								[3, null, null, -2, 2, null],
								[null, -1, 1, null, 2, 1],
								[null, null, null, null, null, null],
								[null, null, 4, null, null, null]]
var first_level_links_on_objects : Array = [[1, 2, 3, null, null, null],
											[null, 1, 1, 1, 1, 1],
											[null, -1, null, null, null, null],
											[1, 1, 1, 1, 1, null],
											[null, -2, null, null, null, null],
											[null, null, null, null, null, null],
											[null, null, null, null, null, null],
											[null, null, null, null, null, null]]

func restert() -> void:
	ElementsManager.restart()
	hp_player = 1000
	boss_on_map = false
	max_hp_player = 1000
	count_level = 0
	spin_skill = 0
	combo_count = 0
	count_experiance = 0
	chance_of_freezing = 0.1
	count_damage_lightning_enemy = 3
	player_balls_after_wave = []
	player_skills = []
	hit_player = false
	first_level_links_on_objects = [[null, null, null, null, null, null],
									[null, 1, 1, 1, 1, 1],
									[null, -1, null, null, null, null],
									[1, 1, 1, 1, 1, null],
									[null, -2, null, null, null, null],
									[null, null, null, null, null, null],
									[null, null, null, null, null, null],
									[null, null, null, null, null, null]]

func add_ball(num_ball) -> void:
	player_balls_after_wave.append(num_ball)

func damage_player(damage) -> void:
	hp_player -= damage

func apeend_new_balls() -> void:
	player_balls.append_array(player_balls_after_wave)
	player_balls_after_wave.clear()

func moving_object(player_position) -> void:
	hit_player = false
	for i in first_level_links_on_objects[7]: # НАНЕСЕНИЕ УРОНА ИГРОКУ
		if i != null:
			if i.has_method("enemy") and !i.has_method("boss"):
				if !i.freezen:
					i.play_animation_hit_player()
					damage_player(i.player_damage)
					hit_player = true
	var boss_shoot = false
	for i in first_level_links_on_objects:
		for j in i:
			if j != null:
				if j.has_method("shoot_at_player") and !j.freezen:
					if j.has_method("boss") and !boss_shoot:
						j.shoot_at_player(player_position)
						boss_shoot = true
					elif !j.has_method("boss"):
						j.shoot_at_player(player_position)
					hit_player = true
	if hit_player:
		await get_tree().create_timer(1.5).timeout

	for i in range(first_level_links_on_objects[7].size()): # УДАЛЕНИЕ ОБЪЕКТОВ С ПОСЛЕДНЕЙ СТРОЧКИ
		if first_level_links_on_objects[7][i] != null:
			if first_level_links_on_objects[7][i].has_method("enemy") and !first_level_links_on_objects[7][i].has_method("boss"):
				if !first_level_links_on_objects[7][i].freezen:
					first_level_links_on_objects[7][i].queue_free()
					first_level_links_on_objects[7][i] = null
			else:
				if !first_level_links_on_objects[7][i].has_method("boss"):
					first_level_links_on_objects[7][i].queue_free()
					first_level_links_on_objects[7][i] = null
	if boss_on_map:  # ДВИГАЕМ БОССА ЕСЛИ ОН НА КАРТЕ
		move_boss()
	for i in range(first_level_links_on_objects.size() - 2, -1, -1):
		for j in range(first_level_links_on_objects[i].size()): # СНАЧАЛА ПРОДВИГАЕМ ВПЁРЕД ТЕХ У КОГО СПЕРЕДИ ПУСТО
			if first_level_links_on_objects[i][j] != null:
				if first_level_links_on_objects[i+1][j] == null:
					if first_level_links_on_objects[i][j].has_method("enemy") and !first_level_links_on_objects[i][j].has_method("boss"):
						if !first_level_links_on_objects[i][j].freezen:
							move_forward(i, j)
					else:
						if !first_level_links_on_objects[i][j].has_method("boss"):
							move_forward(i, j)

		for j1 in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j1] != null:  # ПОТОМ ДВИГАЕМ ВПРАВО, ВЛЕВО ТЕХ У КОГО ПРЕПЯТСВИЕ СПЕРЕДИ
				if first_level_links_on_objects[i+1][j1] != null:
					if first_level_links_on_objects[i+1][j1].has_method("enemy"):
						if first_level_links_on_objects[i+1][j1].freezen:
							if first_level_links_on_objects[i][j1].has_method("enemy") and !first_level_links_on_objects[i][j1].has_method("boss"):
								if !first_level_links_on_objects[i][j1].freezen:
									move_left_or_right(i, j1)
							else:
								if !first_level_links_on_objects[i][j1].has_method("boss"):
									move_left_or_right(i, j1)

	for i in range(first_level_links_on_objects[7].size()): # ЗАПУСКАЕМ АНИМАЦИЮ У ИГРОКОВ НА ПОСЛЕДНЕЙ СТРОКЕ
		if first_level_links_on_objects[7][i] != null:
			if first_level_links_on_objects[7][i].has_method("enemy"):
					first_level_links_on_objects[7][i].enemy_on_last_line()

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

func move_boss() ->void:
	var free_spots = []
	for i in range(first_level_links_on_objects.size() - 1):
		for j in range(first_level_links_on_objects[i].size() - 1):
			var is_free = true
			for x in range(2):
				for y in range(2):
					if first_level_links_on_objects[i + x][j + y] != null:
						is_free = false
						break
				if not is_free:
					break
			if is_free:
				free_spots.append(Vector2(i, j))
	var new_spot = 0
	var boss_pos
	if free_spots.size() > 0:
		new_spot = free_spots[randi() % free_spots.size()]
	if new_spot:
		for i in range(first_level_links_on_objects.size()):
			for j in range(first_level_links_on_objects[i].size()):
				if first_level_links_on_objects[i][j] != null:
					if first_level_links_on_objects[i][j].has_method("boss"):
						if !first_level_links_on_objects[i][j].freezen:
							boss_pos = Vector2(i, j)
							first_level_links_on_objects[boss_pos.x][boss_pos.y].moving(new_spot - boss_pos)
							for i1 in range(2):
								for j1 in range(2):
									first_level_links_on_objects[new_spot.x + i1][new_spot.y + j1] = first_level_links_on_objects[boss_pos.x][boss_pos.y]
							for i1 in range(2):
								for j1 in range(2):
									first_level_links_on_objects[boss_pos.x + i1][boss_pos.y + j1] = null
							return

func updete_last_line() -> void:
	var new_line_spawn
	var slot_for_new_enemy 
	var free_slots = []
	if count_level >= 19:
		new_line_spawn = [null, null, null, null, null, null]
		if count_level % 2 == 1:
			for i in range(5):
				for j in range(first_level_links_on_objects[i].size()):
					if first_level_links_on_objects[i][j] == null:
						free_slots.append(Vector2(i, j))
			
			for i in [1, 2, 2]:
				slot_for_new_enemy = free_slots[randi() % free_slots.size()]
				first_level_links_on_objects[slot_for_new_enemy.x][slot_for_new_enemy.y] = i
				free_slots.erase(slot_for_new_enemy)
	else:
		#new_line_spawn = WaveGeneration.generetion_new_wave(count_level+1)
		new_line_spawn = first_level_spawn[count_level]
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

func ball_explosion(enemy, damage_ball, color_ball, chance_of_freezing : int = 0) -> void:
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
						if chance_of_freezing == 0:
							first_level_links_on_objects[target_x][target_y].deal_bomb_damage(damage_ball, color_ball)
						else:
							first_level_links_on_objects[target_x][target_y].deal_freezing_damage(damage_ball, color_ball)
						combo_count += 1 # можно будет убрать

func lighthing_ball_damage(enemy, damage_ball, color_ball):
	var enemy_arr = []
	var enemy_pos : Vector2
	for i in range(first_level_links_on_objects.size()):
			for j in range(first_level_links_on_objects[i].size()):
				if first_level_links_on_objects[i][j] != null:
					if first_level_links_on_objects[i][j] == enemy:
						enemy_pos = first_level_links_on_objects[i][j].global_position
						break
	for i in first_level_links_on_objects:
		for j in i:
			if j != null:
				if j.has_method("enemy"):
					enemy_arr.append(j)
	for i in range(count_damage_lightning_enemy):
		var num_enemy = randi() % enemy_arr.size()
		if enemy_arr[num_enemy] != enemy and enemy_arr[num_enemy].alive:
			var effect = line_lightning.instantiate()
			effect.points[0] = enemy_pos
			effect.points[1] = enemy_arr[num_enemy].global_position
			enemy_arr[num_enemy].deal_damage(damage_ball, color_ball)
			enemy_arr.remove_at(num_enemy)
			get_tree().current_scene.add_child(effect)
			combo_count += 1

func delete_freezing_and_fire_on_enemy() -> void:
	for i in first_level_links_on_objects:
		for j in i:
			if j != null and typeof(j) != 2:
				if j.has_method("enemy"):
					j.delete_freezing_and_fire()

func update_combo_count() -> void:
	combo_count += 1

func enemy_died(enemy) -> void:
	if "Молния смерти" in player_skills:
		lighthing_ball_damage(enemy, 200 * ElementsManager.lightning_modifier, ElementsManager.color_elements["LIGHTNING"])
	if "Холод смерти" in player_skills:
		ball_explosion(enemy, 200 * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"], 1)
	if "Бомба смерти" in player_skills or enemy.has_method("bomb_enemy"):
		ball_explosion(enemy, 200 * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])

func buy_skill(skill_cost : int) -> void:
	count_experiance -= skill_cost
