extends Node

var player_balls = [1]
var player_balls_after_wave = []
var count_level = 0
var first_level = [[1, 0, 1, 1, 0, 1],
				   [1, 1, 1, 1, 1, 1],
				   [1, 1, 1, 0, 1, 1],
				   [1, 0, 1, 0, 1, 1],
				   [0, 0, 0, 0, 0, 0],
				   [0, 0, 0, 0, 0, 0],
				   [0, 0, 0, 0, 0, 0],
				   [0, 0, 0, 0, 0, 0]]
var first_level_spawn = [[0, 1, 0, 1, 0, 1], # 20 уровней
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 1, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 0, 0, 1, 0]]
var first_level_links_on_objects = [[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0]]

func restert() -> void:
	count_level = 0
	first_level =  [[1, 0, 1, 1, 0, 1],
					[1, 1, 1, 1, 1, 1],
					[1, 1, 1, 0, 1, 1],
					[1, 0, 1, 0, 1, 1],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0]]
	first_level_spawn = [[0, 1, 0, 1, 0, 1],
						 [1, 0, 0, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 0, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 0, 0, 1, 0],
						 [0, 1, 0, 1, 0, 1],
						 [1, 0, 0, 0, 1, 0]]
	first_level_links_on_objects = [[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0],
									[0, 0, 0, 0, 0, 0]]

func add_ball() -> void:
	player_balls_after_wave.append(1)

func apeend_new_balls() -> void:
	player_balls.append_array(player_balls_after_wave)
	player_balls_after_wave.clear()

func updete_last_line() -> void:
	first_level = first_level.slice(0, 7)
	first_level_links_on_objects = first_level_links_on_objects.slice(0, 7)
	if count_level >= 19:
		first_level_links_on_objects.insert(0, [0, 0, 0, 0, 0, 0])
		first_level.insert(0, [0, 0, 0, 0, 0, 0])
	else:
		first_level_links_on_objects.insert(0, first_level_spawn[count_level])
		first_level.insert(0, first_level_spawn[count_level])
	count_level += 1 

func bomb_ball_explosion(enemy, damage_ball) -> void:
	var x
	var y
	for i in range(first_level_links_on_objects.size()):
		for j in range(first_level_links_on_objects[i].size()):
			if first_level_links_on_objects[i][j] != null and typeof(first_level_links_on_objects[i][j]) != 2:
				if first_level_links_on_objects[i][j] == enemy:
					x = i
					y = j
					break
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var target_x = x + dx
			var target_y = y + dy
			if target_x >= 0 and target_x < 8 and target_y >= 0 and target_y < 6:
				if first_level_links_on_objects[target_x][target_y] != null and typeof(first_level_links_on_objects[target_x][target_y]) != 2:
					first_level_links_on_objects[target_x][target_y].deal_bomb_damage(damage_ball)
