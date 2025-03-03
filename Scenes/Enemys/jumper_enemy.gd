extends "res://Scenes/Enemys/defalt_enemy.gd"

var count_jump : int = 0
@onready var move_sound = $Move_sound

func jumper_enemy() -> void:
	pass

func jump() -> void:
	var free_spot_on_map : Array = LevelManager.find_all_free_spot()
	if count_jump >= 2:
		var free_spot_on_last_line = []
		for i in range(LevelManager.first_level_links_on_objects[7].size()):
			if LevelManager.first_level_links_on_objects[7][i] == null:
				free_spot_on_last_line.append(Vector2(7, i))
		if free_spot_on_last_line != [] and free_spot_on_last_line.size() != 0:
			free_spot_on_map = free_spot_on_last_line

	if free_spot_on_map != [] and free_spot_on_map.size() != 0:
		var self_spot = null
		for i in range(LevelManager.first_level_links_on_objects.size() - 1):
			for j in range(LevelManager.first_level_links_on_objects[i].size()):
				if LevelManager.first_level_links_on_objects[i][j] == self:
					self_spot = Vector2(i, j)
					break
		var new_spot = free_spot_on_map[randi() % free_spot_on_map.size()]
		LevelManager.first_level_links_on_objects[new_spot.x][new_spot.y] = self
		LevelManager.first_level_links_on_objects[self_spot.x][self_spot.y] = null
		move_on_this_wave = true
		count_jump += 1
		animation_enemy.play("Move")
		move_sound.pitch_scale = AudioManager.get_random_pitch()
		move_sound.play()
		var end_pos = Vector2((new_spot - self_spot) * Vector2(103, 103))
		end_pos = Vector2(end_pos.y, end_pos.x)
		create_tween().tween_property(self, "global_position", self.global_position + end_pos, 1)
		await get_tree().create_timer(1).timeout
		if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
			if on_last_line:
				animation_enemy.play("Preparation")
			else:
				animation_enemy.play("Idle")
