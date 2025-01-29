extends Node

var player_balls = [3]
var player_balls_after_wave = []
var count_level = 0
var first_level =  [[1, 1, -1, 1, 1, -1],
					[-1, 1, 1, 1, 1, 1],
					[1, 1, 1, -1, 1, -1],
					[-1, 1, -1, 0, 1, 0],
					[1, 0, 0, 0, 0, 0],
					[-1, 0, 1, 0, 0, 1],
					[0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 0]]
var first_level_spawn = [[1, 1, 1, 1, 1, 1],
						[1, 1, 1, 1, 1, 1],
						[1,1,-1,-1,-1,-1],
						[0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0]]
var first_level_links_on_objects = [[0, 0, 0, 0, 0, 0],
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
	first_level_links_on_objects.insert(0, first_level_spawn[count_level])
	first_level.insert(0, first_level_spawn[count_level])
	count_level += 1 

func print_hp():
	for i in first_level_links_on_objects:
		for j in i:
			if j != null and typeof(j) != 2:
				if j.has_method("enemy"):
					print(j.hp_enemy)
