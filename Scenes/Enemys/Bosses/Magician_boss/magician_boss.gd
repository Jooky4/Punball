extends "res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.gd"

@onready var spawn_enemy_sound = $Spawn_enemy
var ENEMY_SPAWN = preload("res://Scenes/Enemys/Dops/magicaian_spawn_enemy.tscn")

func spawn_new_enemy() -> void:
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
		for i in range(LevelManager.first_level_links_on_objects[1].size()):
			if LevelManager.first_level_links_on_objects[1][i] == null:
				free_spot.append(Vector2(1, i))

	for i in range(2):
		if free_spot != [] and free_spot.size() > 0:
			var spot_for_new_enemy = free_spot[randi() % free_spot.size()]
			if get_tree().current_scene.has_method("spawn_objects_by_index"):
				spawn_enemy_sound.pitch_scale += AudioManager.get_random_pitch()
				spawn_enemy_sound.play()
				animation_enemy.play("Cast")
				var count_pos = int((spot_for_new_enemy.x * 6) + (spot_for_new_enemy.y + 1)) - 1 
				LevelManager.first_level_links_on_objects[count_pos/6][count_pos%6] = 11
				get_tree().get_current_scene().call("spawn_objects_by_index", count_pos, 0.25)
				var end_pos = Vector2((spot_for_new_enemy - pos_enemy) * Vector2(103, 103))
				var buff = ENEMY_SPAWN.instantiate()
				buff.global_position = self.global_position
				get_tree().current_scene.add_child(buff)
				buff.go(Vector2(end_pos.y, end_pos.x), count_pos)
				free_spot.erase(spot_for_new_enemy)

func create_label_damage(damage_ball, color_label) -> void:
	var label = LABEL_DAMAGE.instantiate()
	label.global_position = self.global_position
	if typeof(damage_ball) != 3 and typeof(damage_ball) != 2:
		label.text = str(damage_ball)
	elif color_label == ElementsManager.color_elements["HEAL"]:
		label.text = "+" + str(round(damage_ball))
	else:
		label.text = "-" + str(round(damage_ball))
	label.modulate = color_label
	label.scale = Vector2(start_scale_damage_label, start_scale_damage_label)
	get_tree().current_scene.add_child(label)
	label.show_label(125)

func play_animation_hit_player(player_position):
	if animation_enemy and alive: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("Hit")
		hit_sound.pitch_scale += AudioManager.get_random_pitch()
		hit_sound.play()

func boss() -> void:
	pass

func magician_boss() -> void:
	pass
