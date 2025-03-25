extends Node

var LINE_LIGHTNING = preload("res://Scenes/For skills/line_lightning.tscn")
var LASER_LINE = preload("res://Scenes/For skills/laser_line.tscn")
var ICE_CUBE = preload("res://Scenes/For skills/ice_cube.tscn")
var FIRE_BALL = preload("res://Scenes/Balls/Fire_ball/fire_ball.tscn")
var ROCKET = preload("res://Scenes/Balls/Rocket ball/rocket.tscn")
var TRAP = preload("res://Scenes/For skills/trap.tscn")
var THORNS = preload("res://Scenes/For skills/thorns.tscn")
var EFFECT_EXPLOSION = preload("res://Scenes/Effects/BombBallExplosion.tscn")
var EFFECT_EXPLOSION_FREEZE = preload("res://Scenes/Effects/FreezeBombBallExplosion.tscn")

var hp_player : float = 500
var max_hp_player : float = 500
var boss_on_map : bool = false
var player_balls : Array = [1, 1, 1, 1]
var player_balls_after_wave : Array = []
var count_level : int = 0
var count_experiance : int = 0
var combo_count : int = 0
var spin_skill : int = 0
var count_damage_lightning_enemy : int = 3
var chance_of_freezing : float = 0.1
var prosen_hp_plus : float = 1
var hit_player : bool = false
var somebody_move_on_this_wave : bool = false
var player_skills : Array = []
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
var first_level_links_on_objects : Array = [[null, null, null, null, null, null],
 											[null, 1, 1, 1, 1, 1,],
 											[null, null, null, null, null, null],
 											[1, 1, 1, 1, 1, null],
 											[null, null, null, null, null, null],
 											[null, null, null, null, null, null],
 											[null, null, null, null, null, null],
 											[null, null, null, null, null, null]]
var trap_on_map_links = [[null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null]]
var kill_on_whis_wave : int = 0
var win_or_lose = ""

func restert() -> void:
	ElementsManager.restart()
	match PlayerIndicatorsManager.CURRENT_CHARACTER:
		1:
			hp_player = (500 + PlayerIndicatorsManager.FOR_COIS_UP_OZ) * (1 + PlayerIndicatorsManager.FOR_CRYSTAL_UP_OZ) * PlayerIndicatorsManager.CHARACTER_UP_OZ
		2:
			hp_player = (600 + PlayerIndicatorsManager.FOR_COIS_UP_OZ) * (1 + PlayerIndicatorsManager.FOR_CRYSTAL_UP_OZ) * PlayerIndicatorsManager.CHARACTER_UP_OZ
		3:
			hp_player = (750 + PlayerIndicatorsManager.FOR_COIS_UP_OZ) * (1 + PlayerIndicatorsManager.FOR_CRYSTAL_UP_OZ) * PlayerIndicatorsManager.CHARACTER_UP_OZ
	max_hp_player = hp_player
	boss_on_map = false
	count_level = 0
	spin_skill = 0
	combo_count = 0
	count_experiance = 0
	chance_of_freezing = 0.1
	prosen_hp_plus = 1
	count_damage_lightning_enemy = 3
	player_balls_after_wave = []
	player_skills = []
	hit_player = false
	kill_on_whis_wave = 0
	win_or_lose = ""
	first_level_links_on_objects = [[null, null, null, null, null, null],
 									[null, 1, 1, 1, 1, 1,],
 									[null, null, null, null, null, null],
 									[1, 1, 1, 1, 1, null],
 									[null, null, null, null, null, null],
 									[null, null, null, null, null, null],
 									[null, null, null, null, null, null],
 									[null, null, null, null, null, null]]
	trap_on_map_links = [[null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null],
						 [null, null, null, null, null, null]]

func add_ball(num_ball) -> void:
	player_balls_after_wave.append(num_ball)

func damage_player(damage, enemy) -> void:
	if PlayerIndicatorsManager.CURRENT_CHARACTER == 3:
		if randf() <= 0.2:
			get_node("/root/First_level").player_take_damage_create_label("УВОРОТ")
			return
	if enemy.has_method("boss"):
		damage -= PlayerIndicatorsManager.FOR_COIS_DOWN_DAMAGE_BOSS
	elif enemy.has_method("shoot_at_player"):
		damage -= PlayerIndicatorsManager.FOR_COIS_DOWN_DAMAGE_DISTANT_ENEMY
	else:
		damage -= PlayerIndicatorsManager.FOR_COIS_DOWN_DAMAGE_CLOSE_ENEMY

	if damage <= 0:
		damage = 0
	hp_player -= damage
	if hp_player <= 0:
		hp_player = 0
	hp_player = round(hp_player)

	if PlayerIndicatorsManager.CURRENT_CHARACTER == 3:
		update_character_3_damage_from_OZ()
	if damage != 0:
		get_node("/root/First_level").player_take_damage_create_label(damage)

func update_character_3_damage_from_OZ():
	var hp_ratio = clamp(hp_player / max_hp_player, 0.1, 1.0)
	if hp_ratio > 0.5:
		PlayerIndicatorsManager.CHARACTER_3_UP_ATTACK_FROM_OZ =  lerp(1.0, 1.25, (1.0 - hp_ratio)/0.5)
	else:
		PlayerIndicatorsManager.CHARACTER_3_UP_ATTACK_FROM_OZ =  lerp(1.25, 1.5, (0.5 - hp_ratio)/0.4)

func apeend_new_balls() -> void:
	if 11 in player_balls_after_wave:
		player_balls.insert(0, 11)
		player_balls_after_wave.erase(11)
	player_balls.append_array(player_balls_after_wave)
	player_balls_after_wave.clear()

func moving_object(player_position) -> void:
	hit_player = false
	for i in first_level_links_on_objects: # ЖДЁМ ПОКА ЗАСПАВНЯТСЯ ВСЕ СЛИЗИ
		for j in i:
			if j != null:
				if j.has_method("small_slime"):
					if j.animation_enemy.current_animation == "Spawn":
						hit_player = true

	for i in first_level_links_on_objects[7]: # НАНЕСЕНИЕ УРОНА ИГРОКУ С ПОСЛЕДНЕГО РЯДА
		if i != null:
			if i.has_method("enemy") and !i.has_method("boss"):
				if !i.freezen and i.alive:
					i.play_animation_hit_player()
					damage_player(i.player_damage, i)
					hit_player = true

	var boss_shoot = false
	for i in first_level_links_on_objects: # НАНЕСЕНИЕ УРОНА ИГРОКУ ВРАГАМИ ДАЛЬНЕГО БОЯ
		for j in i:
			if j != null:
				if j.has_method("shoot_at_player") and !j.freezen and j.alive:
					if j.has_method("boss") and !boss_shoot:
						j.shoot_at_player(player_position)
						boss_shoot = true
					elif !j.has_method("boss"):
						j.shoot_at_player(player_position)
					hit_player = true

	for i in (first_level_links_on_objects.size() - 1): # ВРАГИ МЕДИКИ ЛЕЧАТ
		for j in (first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null:
				if first_level_links_on_objects[i][j].has_method("medic"):
					if !first_level_links_on_objects[i][j].freezen and first_level_links_on_objects[i][j].alive:
						first_level_links_on_objects[i][j].heal_enemy()
						hit_player = true

	for i in (first_level_links_on_objects.size() - 1): # КОЛДУНЫ СПАВНЯТ НОВЫХ ВРАГОВ
		for j in (first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null:
				if first_level_links_on_objects[i][j].has_method("magician_enemy"):
					if !first_level_links_on_objects[i][j].freezen and first_level_links_on_objects[i][j].alive:
						first_level_links_on_objects[i][j].spawn_new_enemy()
						hit_player = true
	if hit_player:
		await get_tree().create_timer(1.7).timeout

	for i in first_level_links_on_objects:
		for j in i:
			if j != null:
				j.move_on_this_wave = false
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

	somebody_move_on_this_wave = false
	if boss_on_map:  # ДВИГАЕМ БОССА ЕСЛИ ОН НА КАРТЕ
		move_boss()

	for i in first_level_links_on_objects: # СНАЧАЛА ПРЫГАЮТ ВСЕ ПРЫГУНЫ
		for j in i:
			if j != null:
				if j.has_method("jumper_enemy"):
					if !j.freezen and j.alive and j.move_on_this_wave == false:
						j.jump()

	for i in range(first_level_links_on_objects.size() - 2, -1, -1): # ПОТОМ ПРОДВИГАЕМ ВПЁРЕД ТЕХ У КОГО СПЕРЕДИ ПУСТО
		for j in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null:
				if first_level_links_on_objects[i+1][j] == null:
					if first_level_links_on_objects[i][j].has_method("enemy") and !first_level_links_on_objects[i][j].has_method("boss"):
						if !first_level_links_on_objects[i][j].freezen and first_level_links_on_objects[i][j].alive:
							move_forward(i, j)
					else:
						if !first_level_links_on_objects[i][j].has_method("boss"):
							move_forward(i, j)
	for i in range(first_level_links_on_objects.size() - 2, -1, -1): # ПОТОМ ДВИГАЕМ ВПРАВО, ВЛЕВО ТЕХ У КОГО ПРЕПЯТСВИЕ СПЕРЕДИ
		for j in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null: 
				if first_level_links_on_objects[i+1][j] != null:
					if first_level_links_on_objects[i+1][j].has_method("enemy"):
						if first_level_links_on_objects[i+1][j].freezen:
							if first_level_links_on_objects[i][j].has_method("enemy"):
								if !first_level_links_on_objects[i][j].freezen and first_level_links_on_objects[i][j].alive:
									move_left_or_right(i, j)
							else:
								if !first_level_links_on_objects[i][j].has_method("boss"):
									move_left_or_right(i, j)
	for i in range(first_level_links_on_objects[7].size()): # ЗАПУСКАЕМ АНИМАЦИЮ У ИГРОКОВ НА ПОСЛЕДНЕЙ СТРОКЕ
		if first_level_links_on_objects[7][i] != null:
			if first_level_links_on_objects[7][i].has_method("enemy"):
				first_level_links_on_objects[7][i].enemy_on_last_line()
	if somebody_move_on_this_wave == true:
		AudioManager.enemy_move()
	await get_tree().create_timer(1).timeout
	check_traps()

func move_forward(i, j) -> void:
	if !first_level_links_on_objects[i][j].move_on_this_wave:
		first_level_links_on_objects[i][j].moving("forward")
		first_level_links_on_objects[i][j].move_on_this_wave = true
		first_level_links_on_objects[i+1][j] = first_level_links_on_objects[i][j]
		first_level_links_on_objects[i][j] = null
		somebody_move_on_this_wave = true

func move_left_or_right(i, j) -> void:
	if !first_level_links_on_objects[i][j].move_on_this_wave:
		if j != 0:
			if first_level_links_on_objects[i][j-1] == null:
				first_level_links_on_objects[i][j].moving("left")
				first_level_links_on_objects[i][j].move_on_this_wave = true
				first_level_links_on_objects[i][j-1] = first_level_links_on_objects[i][j]
				first_level_links_on_objects[i][j] = null
				somebody_move_on_this_wave = true
			else:
				if j != 5:
					if first_level_links_on_objects[i][j+1] == null:
						first_level_links_on_objects[i][j].moving("right")
						first_level_links_on_objects[i][j].move_on_this_wave = true
						first_level_links_on_objects[i][j+1] = first_level_links_on_objects[i][j]
						first_level_links_on_objects[i][j] = null
						somebody_move_on_this_wave = true
				else:
					print(i+1," ", j+1, ": ВСЁ ЗАНЯТО Я ТУТ ОСТАНУСЬ")

func move_boss() -> void:
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

func check_traps() -> void:
	for i in range(first_level_links_on_objects.size()):
		for j in range(first_level_links_on_objects[i].size()):
			if trap_on_map_links[i][j] != null:
				if first_level_links_on_objects[i][j] != null:
					if first_level_links_on_objects[i][j].has_method("enemy"):
						trap_on_map_links[i][j].delete_trap(first_level_links_on_objects[i][j])
						trap_on_map_links[i][j] = null

func updete_last_line() -> void:
	var new_line_spawn
	var slot_for_new_enemy 
	var free_slots = []
	if boss_on_map and WaveGeneration.get_count_wave_on_location() - 1 >= 19:
		if count_level % 2 == 1:
			for i in range(5):
				for j in range(first_level_links_on_objects[i].size()):
					if first_level_links_on_objects[i][j] == null:
						free_slots.append(Vector2(i, j))

			for i in [1, 2, 2]:
				slot_for_new_enemy = free_slots[randi() % free_slots.size()]
				first_level_links_on_objects[slot_for_new_enemy.x][slot_for_new_enemy.y] = i
				free_slots.erase(slot_for_new_enemy)
			count_level += 1
			await get_tree().create_timer(0.8).timeout
			AudioManager.enemy_spawn()
		else:
			count_level += 1
	else:
		if WaveGeneration.current_location == 1:
			new_line_spawn = first_level_spawn[count_level]
		else:
			new_line_spawn = WaveGeneration.generetion_new_wave(count_level+2)

		var can_spawn = true
		for i in first_level_links_on_objects[1]:
			if i != null:
				return
		if can_spawn:
			for i in range(new_line_spawn.size()):
				if new_line_spawn[i] != null:
					first_level_links_on_objects[1][i] = new_line_spawn[i]
			count_level += 1
			for i in new_line_spawn:
				if i != null:
					if i > 0:
						await get_tree().create_timer(0.8).timeout
						AudioManager.enemy_spawn()
						break

func ball_explosion(enemy, damage_ball, color_ball, create_sound : bool = false) -> void:
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
						if first_level_links_on_objects[target_x][target_y].alive:
							if color_ball == ElementsManager.color_elements["POISON"]:
								first_level_links_on_objects[target_x][target_y].poisoning()
								AudioManager.bomb_sound()
							elif color_ball == ElementsManager.color_elements["FIRE"]:
								first_level_links_on_objects[target_x][target_y].deal_bomb_damage(damage_ball, color_ball)
								if create_sound:
									AudioManager.bomb_sound()
							elif color_ball == ElementsManager.color_elements["FROST"]:
								first_level_links_on_objects[target_x][target_y].deal_freezing_damage(damage_ball, color_ball)
								if create_sound:
									AudioManager.freezing_bomb_sound()
							combo_count += 1 
							check_count_combo(first_level_links_on_objects[target_x][target_y])

func lighthing_ball_damage(enemy, damage_ball, color_ball, create_sound : bool = false) -> void:
	var enemy_arr = find_all_enemys()
	var enemy_pos : Vector2 = enemy.global_position
	for i in enemy_arr:
		if i == enemy:
			enemy_arr.erase(i)
	if enemy_arr != [] and enemy_arr.size() != 0:
		if enemy_arr.size() >= 1 and create_sound:
			AudioManager.lightning_sound()
		for i in range(count_damage_lightning_enemy):
			if enemy_arr.size() != 0:
				var num_enemy = randi() % enemy_arr.size()
				if enemy_arr[num_enemy] != enemy and enemy_arr[num_enemy].alive:
					var effect = LINE_LIGHTNING.instantiate()
					for w in range(effect.points.size()):
						effect.points[w] = enemy_pos + (((enemy_arr[num_enemy].global_position - enemy_pos) / 6) * w)
					enemy_arr[num_enemy].deal_damage(damage_ball, color_ball)
					combo_count += 1
					check_count_combo(enemy_arr[num_enemy])
					enemy_arr.remove_at(num_enemy)
					get_tree().current_scene.add_child(effect)

func laser_ball_damage(enemy, damage_ball, color_ball, line_damage) -> void:
	var horizontal
	var vertical
	var pos_enemy 
	for i in range(first_level_links_on_objects.size()):
		for j in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null:
				if first_level_links_on_objects[i][j] == enemy:
					horizontal = i
					vertical = j
					pos_enemy = first_level_links_on_objects[i][j].global_position
					break
	if horizontal != null and vertical != null:
		if "Повелитель лазера" in player_skills:
			laser_ball_damage_horizontally(damage_ball, color_ball, horizontal, pos_enemy)
			laser_ball_damage_vertically(damage_ball, color_ball, vertical, pos_enemy)
		else:
			if line_damage == 0:
				laser_ball_damage_horizontally(damage_ball, color_ball, horizontal, pos_enemy)
			elif line_damage == 1:
				laser_ball_damage_vertically(damage_ball, color_ball, vertical, pos_enemy)

func laser_ball_damage_horizontally(damage_ball, color_ball, line_damage, pos_enemy) -> void:
	var effect = LASER_LINE.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = Vector2(358, pos_enemy.y)
	effect.show_line(0)
	for i in first_level_links_on_objects[line_damage]:
		if i != null:
			if i.has_method("enemy"):
				if i.alive:
					i.deal_damage(damage_ball * ElementsManager.laser_modifier, color_ball)

func laser_ball_damage_vertically(damage_ball, color_ball, line_damage, pos_enemy) -> void:
	var effect = LASER_LINE.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = Vector2(pos_enemy.x, 644)
	effect.show_line(1)
	for i in first_level_links_on_objects.map(func(row): return row[line_damage]):
		if i != null:
			if i.has_method("enemy"):
				if i.alive:
					i.deal_damage(damage_ball * ElementsManager.laser_modifier, color_ball)

func rocket_ball_damage(enemy, damage_ball, color_ball, start_pos, count_rocket, combo : bool = false) -> void:
	var enemy_arr : Array = find_all_enemys()
	var weak_enemy
	var min_hp = 10000000
	if enemy_arr != [] and enemy_arr.size() != 1:
		for i in enemy_arr:
			if i.hp_enemy < min_hp and i != enemy and i.alive:
				weak_enemy = i
				min_hp = i.hp_enemy
		if "Повелитель атома" in player_skills:
			count_rocket += 1
		for i in range(count_rocket):
			var rocket = ROCKET.instantiate()
			rocket.rocket_damage = damage_ball
			if combo:
				rocket.global_position = Vector2(358, -200)
				rocket.arc_height += 200 + (100 * i)
				rocket.speed = 1200
			else:
				rocket.global_position = start_pos
				rocket.arc_height += -50 * i
			get_tree().current_scene.add_child(rocket)
			if combo:
				rocket.go(weak_enemy, Vector2(358, -200))
			else:
				rocket.go(weak_enemy, start_pos)

func delete_freezing_and_fire_on_enemy() -> void:
	for i in first_level_links_on_objects:
		for j in i:
			if j != null and typeof(j) != 2:
				if j.has_method("enemy"):
					j.delete_freezing_and_fire()

func update_combo_count(enemy) -> void:
	combo_count += 1
	check_count_combo(enemy)

func enemy_died(enemy) -> void:
	kill_on_whis_wave += 1
	if "Молния смерти" in player_skills:
		lighthing_ball_damage(enemy, 600 * ElementsManager.lightning_modifier, ElementsManager.color_elements["LIGHTNING"], true)
	if "Холод смерти" in player_skills:
		ball_explosion(enemy, 300 * ElementsManager.frost_modifier, ElementsManager.color_elements["FROST"], true)
		var effect = EFFECT_EXPLOSION_FREEZE.instantiate()
		effect.global_position = enemy.global_position
		get_tree().current_scene.add_child(effect)
	if "Бомба смерти" in player_skills or enemy.has_method("bomb_enemy"):
		ball_explosion(enemy, 400 * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"], true)
		if "Бомба смерти" in player_skills and !enemy.has_method("bomb_enemy") and !enemy.has_method("poison_enemy"):
			var effect = EFFECT_EXPLOSION.instantiate()
			effect.global_position = enemy.global_position
			get_tree().current_scene.add_child(effect)
	if "Лазер смерти" in player_skills:
		laser_ball_damage(enemy, 600 * ElementsManager.laser_modifier, ElementsManager.color_elements["LASER"], 0)
		AudioManager.liser_sound()
	if "Ракета смерти" in player_skills:
		rocket_ball_damage(enemy, 900 * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"], enemy.global_position, 2)
	if "Ловушка" in player_skills:
		for i in range(first_level_links_on_objects.size()):
			for j in range(first_level_links_on_objects[i].size()):
				if first_level_links_on_objects[i][j] != null:
					if first_level_links_on_objects[i][j] == enemy:
						var buff = TRAP.instantiate()
						buff.global_position = first_level_links_on_objects[i][j].global_position
						trap_on_map_links[i][j] = buff
						get_tree().current_scene.add_child(buff)
						break
	if enemy.has_method("poison_enemy"):
		ball_explosion(enemy, 0, ElementsManager.color_elements["POISON"])

	for i in range(first_level_links_on_objects.size()):
		for j in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] == enemy:
				first_level_links_on_objects[i][j] = null
				break

func buy_skill(skill_cost : int) -> void:
	count_experiance -= skill_cost
	if count_experiance <= 0:
		count_experiance = 0

func check_count_combo(enemy) -> void:
	var need_combo = 40
	if "Комбо: скидка" in player_skills:
		need_combo = 40 * 0.9
	if combo_count % int(need_combo) == 0:
		var enemy_arr : Array = find_all_enemys()
		if enemy_arr.size() != 0:
			if "Молния: комбо" in player_skills:
				for i in range(count_damage_lightning_enemy):
					if enemy_arr.size() != 0:
						var num_enemy = randi() % enemy_arr.size()
						if enemy_arr[num_enemy].alive:
							var effect = LINE_LIGHTNING.instantiate()
							var enemy_pos = Vector2(enemy_arr[num_enemy].global_position.x, -200)
							get_tree().current_scene.add_child(effect)
							AudioManager.lightning_sound()
							for w in range(6):
								effect.points[w] = enemy_pos + (((enemy_arr[num_enemy].global_position - enemy_pos) / 6) * (w + 1))
							enemy_arr[num_enemy].deal_damage(200 * ElementsManager.lightning_modifier, ElementsManager.color_elements["LIGHTNING"])
							enemy_arr.remove_at(num_enemy)
							combo_count += 1
		enemy_arr = find_all_enemys()
		if enemy_arr.size() != 0:
			if "Лед: комбо" in player_skills:
				var ice_cube_spawn = false
				while ice_cube_spawn == false:
					var num_enemy = randi() % enemy_arr.size()
					if enemy_arr[num_enemy].alive:
						var effect = ICE_CUBE.instantiate()
						get_tree().current_scene.add_child(effect)
						effect.ice_cube_go(enemy_arr[num_enemy])
						AudioManager.freezing_combo_sound()
						combo_count += 1
						ice_cube_spawn = true
		enemy_arr = find_all_enemys()
		if enemy_arr.size() != 0:
			if "Огонь: комбо" in player_skills:
				var fire_ball_spawn = false
				while fire_ball_spawn == false:
					var num_enemy = randi() % enemy_arr.size()
					if enemy_arr[num_enemy].alive:
						var effect = FIRE_BALL.instantiate()
						get_tree().current_scene.add_child(effect)
						effect.combo_go(enemy_arr[num_enemy])
						AudioManager.fire_combo_sound()
						combo_count += 1
						fire_ball_spawn = true
		enemy_arr = find_all_enemys()
		if enemy_arr.size() != 0:
			if "Лазер: комбо" in player_skills:
				laser_ball_damage(enemy, 200 * ElementsManager.laser_modifier, ElementsManager.color_elements["LASER"], 0)
				AudioManager.liser_sound()
		enemy_arr = find_all_enemys()
		if enemy_arr.size() != 0:
			if "Ядерная: комбо" in player_skills:
				rocket_ball_damage(enemy, 300 * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"], enemy.global_position, 2, true)
		enemy_arr = find_all_enemys()
		if enemy_arr.size() != 0:
			if "Технология: комбо с фронта" in player_skills:
				combo_thorns()
		enemy_arr = find_all_enemys()
		if enemy_arr.size() != 0:
			if "Технология: комбо с тыла" in player_skills:
				combo_thorns(true)

func find_all_enemys():
	var enemy_arr = []
	for i in first_level_links_on_objects:
		for j in i:
			if j != null:
				if j.has_method("enemy"):
					if j.alive:
						enemy_arr.append(j)
	return enemy_arr

func find_all_free_spot():
	var free_spots = []
	for i in range(first_level_links_on_objects.size() - 1):
		if i != 0 and i != 1:
			for j in range(first_level_links_on_objects[i].size()):
				if first_level_links_on_objects[i][j] == null:
					free_spots.append(Vector2(i, j))
	return free_spots

func combo_thorns(from_back : bool = false) -> void:
	var line = null
	var count_enemy_damage = 0
	for i in range(first_level_links_on_objects.size() - 2, -1, -1):
		for j in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null:
				if first_level_links_on_objects[i][j].has_method("enemy"):
					if first_level_links_on_objects[i][j].alive:
						line = i
						if !from_back:
							break
		if line != null and !from_back:
			break
	if line != null:
		for i in first_level_links_on_objects[line]:
			if i != null:
				if i .has_method("enemy"):
					if i.alive:
						AudioManager.thorns_combo_sound()
						create_thorns(i)
						count_enemy_damage += 1
						if count_enemy_damage == 2:
							break

func create_thorns(enemy) -> void:
	var throns_cop = THORNS.instantiate()
	throns_cop.global_position = enemy.global_position
	get_tree().current_scene.add_child(throns_cop)
	throns_cop.damage_enemy(enemy)

func heal_hp_plaer_from_technologies() -> void:
	if "Повелитель технологий" in player_skills:
		var prosen_hp_plus = 0.02
		if "Прибавка к восстановлению" in LevelManager.player_skills:
				prosen_hp_plus *= 1.5
		hp_player += round(max_hp_player*prosen_hp_plus)
		if hp_player > max_hp_player:
			hp_player += max_hp_player

func revival(hp_player_prozent : float = 1, delete_enemy : bool = false):
	if hp_player_prozent == 1:
		hp_player = max_hp_player
	else:
		hp_player = round(max_hp_player * hp_player_prozent)
	if delete_enemy:
		for i in range(5, len(first_level_links_on_objects)):
			for j in range(first_level_links_on_objects[i].size()):
				if first_level_links_on_objects[i][j] != null:
					if first_level_links_on_objects[i][j].has_method("enemy") and !first_level_links_on_objects[i][j].has_method("boss"):
						first_level_links_on_objects[i][j].queue_free()
						first_level_links_on_objects[i][j] = null
	AudioManager.health_sound()
	player_skills.erase("Оживление")
