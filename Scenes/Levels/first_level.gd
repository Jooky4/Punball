extends Node2D

enum {
	PLAY,
	BALLS_GO,
	WIN,
	LOSE,
	PAUSE,
	CHOOSE_SKILL
}

var game_state = PLAY

@onready var hp_player_bar = $Dicariations/Start_bullet_position/Start_bullet_position/Player_hp_bar
@onready var hp_player_label = $Dicariations/Start_bullet_position/Start_bullet_position/Player_hp_label

var DEFALT_ENEMY = preload("res://Scenes/Enemys/defalt_enemy.tscn")
var DEFALT_ENEMY_2 = preload("res://Scenes/Enemys/defalt_enemy_2.tscn")
var DEFALT_ENEMY_3 = preload("res://Scenes/Enemys/defalt_enemy_3.tscn")
var BONUS_BALL = preload("res://Scenes/Bonus/bonus_ball.tscn")
var SKILL_BOX = preload("res://Scenes/Bonus/skill_box.tscn")
var DEFALT_BALL = preload("res://Scenes/Balls/Defalt ball/defalt_ball.tscn")
var CRUNBLING_BALL = preload("res://Scenes/Balls/Сrumbling ball/crumbling_ball.tscn")
var BOMB_BALL = preload("res://Scenes/Balls/Bomb ball/bomb_ball.tscn")
var FREEZING_BALL = preload("res://Scenes/Balls/Freezing ball/freezing_ball.tscn")

@onready var end_game_UI = $UI/End_game
@onready var end_game_UI_win = $UI/End_game/Win
@onready var end_game_UI_lose = $UI/End_game/Lose
@onready var choose_skill_UI = $UI/Get_skill_UI
@onready var combo_count_label = $UI/Combo_count
@onready var count_experience_label = $UI/Count_experience
var combo_count : int = 0

@onready var game_objects = $Game_objects

@onready var count_level_label = $UI/Count_level_label

@onready var count_ball_label = $Dicariations/Start_bullet_position/Start_bullet_position/Count_bullet_label
@onready var raycast_detection_walls = $Dicariations/Start_bullet_position/Start_bullet_position/Detection_walls
@onready var line = $Dicariations/Start_bullet_position/Line2D
@onready var start_balls_position = $Dicariations/Start_bullet_position/Start_bullet_position
@onready var strelka = $Dicariations/Start_bullet_position/Strelka
@onready var ball_rotate_UI = $Dicariations/Start_bullet_position/Ball_rotate_UI

var old_coord_mouse : Vector2 = Vector2.ZERO
var direction = Vector2.ZERO
var balls_can_go : bool = true
var new_position_balls = 0
var rignt_extreme_point : Vector2
var left_extreme_point : Vector2

func _ready() -> void:
	spawn_objects_on_matrix(1)
	count_ball_label.text = "x" + str(LevelManager.player_balls.size())
	count_level_label.text = str(LevelManager.count_level + 1)
	count_experience_label.text = str(LevelManager.count_experiance)
	rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
	left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()
	hp_player_bar.max_value = LevelManager.max_hp_player
	hp_player_bar.value = LevelManager.hp_player
	hp_player_label.text = str(LevelManager.hp_player)
	#YandexSDK.gameplay_started()

func _process(delta):
	match game_state:
		PLAY:
			play_game()
		BALLS_GO:
			chec_game_end()
		WIN:
			win()
		LOSE:
			lose()
		PAUSE:
			pause()
		CHOOSE_SKILL:
			if !choose_skill_UI.visible:
				hp_player_bar.max_value = LevelManager.max_hp_player
				hp_player_bar.value = LevelManager.hp_player
				hp_player_label.text = str(LevelManager.hp_player)
				LevelManager.apeend_new_balls()
				count_ball_label.text = "x" + str(LevelManager.player_balls.size())
				balls_can_go = true
				game_state = PLAY

func play_game() -> void:
	if Input.is_action_pressed("LBM") and balls_can_go:
		if get_global_mouse_position() != old_coord_mouse:
			line.visible = true
			ball_rotate_UI.visible = true
			strelka.visible = true
			direction = (get_global_mouse_position() - start_balls_position.position).normalized()
			if !(rad_to_deg(rignt_extreme_point.angle()) >= rad_to_deg(direction.angle()) and rad_to_deg(left_extreme_point.angle()) <= rad_to_deg(direction.angle())):
				if rad_to_deg(left_extreme_point.angle()) >= rad_to_deg(direction.angle()) or rad_to_deg(direction.angle()) >= 90:
					direction = Vector2.from_angle(left_extreme_point.angle())
				elif rad_to_deg(rignt_extreme_point.angle()) <= rad_to_deg(direction.angle()) or 90 >= rad_to_deg(direction.angle()):
					direction = Vector2.from_angle(rignt_extreme_point.angle())
			old_coord_mouse = get_global_mouse_position()
			draw_trajectory()

	if Input.is_action_just_released("LBM") and balls_can_go:
		balls_go()

func chec_game_end() -> void:
	var balls_on_map = true
	var enemy_alive = false
	for child in game_objects.get_children():
		if child.has_method("enemy"):
			enemy_alive = true
			break
	if enemy_alive == false:
		game_state = WIN

	for child in get_children():
		if "CharacterBody2D" in child.name or "ball" in child.name:
			balls_on_map = false
			break

	if balls_on_map and enemy_alive and count_ball_label.text == "x0" and !balls_can_go:
		LevelManager.apeend_new_balls()
		count_ball_label.text = "x" + str(LevelManager.player_balls.size())
		count_level_label.text = str(LevelManager.count_level + 2)
		combo_count_label.visible = false
		combo_count = 0
		LevelManager.combo_count = 0
		combo_count_label.text = str(0)

		for i in self.get_children():
			if i.has_method("bank_with_experience"):
				var tween = get_tree().create_tween()
				tween.tween_property(i, "position", Vector2(92, 80), 0.7)
		await get_tree().create_timer(0.7).timeout
		for i in self.get_children():
			if i.has_method("bank_with_experience"):
				LevelManager.count_experiance += i.experience
				count_experience_label.text = str(LevelManager.count_experiance)
				i.queue_free()

		start_balls_position.position.x += new_position_balls
		rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
		left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()
		LevelManager.enemy_shoot(start_balls_position.position)
		LevelManager.moving_object()
		await get_tree().create_timer(1).timeout
		print(LevelManager.hp_player)
		if LevelManager.hp_player <= 0:
			hp_player_bar.value = 0
			hp_player_label.text = "0"
			game_state = LOSE
			return
		else:
			hp_player_bar.value = LevelManager.hp_player
			hp_player_label.text = str(LevelManager.hp_player)
		LevelManager.updete_last_line()
		spawn_objects_on_matrix()
		if LevelManager.spin_skill != 0:
			choose_skill_UI.visible = true
			choose_skill_UI.get_number_skill(LevelManager.spin_skill)
			game_state = CHOOSE_SKILL
			return
		balls_can_go = true
		game_state = PLAY
	
	if LevelManager.combo_count > combo_count:
		combo_count_label.visible = true
		combo_count_label.text = str(LevelManager.combo_count)
		combo_count_label.scale = Vector2(1.5, 1.5)
		combo_count = LevelManager.combo_count
	else:
		if combo_count_label.scale > Vector2(1, 1):
			combo_count_label.scale -= Vector2(0.05, 0.05)

func win() -> void:
	end_game_UI.visible = true
	end_game_UI_win.visible = true

func lose() -> void:
	end_game_UI.visible = true
	end_game_UI_lose.visible = true

func pause() -> void:
	pass

func _on_start_again_pressed() -> void:
	LevelManager.restert()
	LevelManager.player_balls = [1, 1, 1, 1]
	get_tree().reload_current_scene()

func draw_trajectory() -> void:
	strelka.points[0] = start_balls_position.position
	strelka.points[1] = start_balls_position.position + (direction * 100)
	line.points[0] = start_balls_position.position + (direction * 100)
	ball_rotate_UI.position = start_balls_position.position
	ball_rotate_UI.direction_bullet = direction
	ball_rotate_UI.stop = false
	raycast_detection_walls.target_position = direction * 2000
	raycast_detection_walls.force_raycast_update()

	while !ball_rotate_UI.stop:
		ball_rotate_UI.ball_go()

	if (start_balls_position.position.distance_to(strelka.points[1])) > (start_balls_position.position.distance_to(ball_rotate_UI.position)):
		strelka.points[1] = ball_rotate_UI.position
		line.points[0] = ball_rotate_UI.position

	if "Wall" not in ball_rotate_UI.collider_name:
		line.points[1] = raycast_detection_walls.get_collision_point()
	else:
		line.points[1] = ball_rotate_UI.position

func balls_go() -> void:
	if balls_can_go:
		balls_can_go = false
		LevelManager.delete_freezing_on_enemy()
		line.visible = false
		strelka.visible = false
		ball_rotate_UI.visible = false
		new_position_balls = 0
		game_state = BALLS_GO

		for i in range(LevelManager.player_balls.size()):
			var ball
			if LevelManager.player_balls[i] == 1:
				ball = DEFALT_BALL.instantiate()
			elif LevelManager.player_balls[i] == 2:
				ball = CRUNBLING_BALL.instantiate()
			elif LevelManager.player_balls[i] == 3:
				ball = BOMB_BALL.instantiate()
			elif LevelManager.player_balls[i] == 4:
				ball = FREEZING_BALL.instantiate()
			ball.position = start_balls_position.position
			ball.direction_bullet = direction
			get_tree().current_scene.add_child(ball)
			count_ball_label.text = "x" + str(LevelManager.player_balls.size() - (i+1))
			await get_tree().create_timer(0.1).timeout

func _on_area_2d_body_entered(body: Node2D) -> void:
	if ("CharacterBody2D" in body.name or "ball" in body.name):
		if body.direction_bullet.y > 0:
			if new_position_balls == 0:
				new_position_balls = body.position.x
				if new_position_balls > start_balls_position.position.x:
					new_position_balls = new_position_balls - start_balls_position.position.x
				else:
					new_position_balls = -(start_balls_position.position.x - new_position_balls)
			body.queue_free()

func spawn_objects_on_matrix(inex: int = 100) -> void:
	var count = -1
	if inex == 1:
		for i in LevelManager.first_level_links_on_objects:
			for j in i:
				count += 1
				spawn_objects_by_index(count)
	else:
		for i in LevelManager.first_level_links_on_objects[0]:
			count += 1
			spawn_objects_by_index(count)

func spawn_objects_by_index(count) -> void:
	if typeof(LevelManager.first_level_links_on_objects[count/6][count%6]) == 2:
		if LevelManager.first_level_links_on_objects[count/6][count%6] == 1:
			var enemy = DEFALT_ENEMY.instantiate()
			enemy.hp_enemy += WaveGeneration.how_many_hp_plus_enemy(LevelManager.count_level)
			enemy.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
			LevelManager.first_level_links_on_objects[count/6][count%6] = enemy
			game_objects.add_child(enemy)
		elif LevelManager.first_level_links_on_objects[count/6][count%6] == 2:
			var enemy = DEFALT_ENEMY_2.instantiate()
			enemy.hp_enemy += WaveGeneration.how_many_hp_plus_enemy(LevelManager.count_level)
			enemy.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
			LevelManager.first_level_links_on_objects[count/6][count%6] = enemy
			game_objects.add_child(enemy)
		elif LevelManager.first_level_links_on_objects[count/6][count%6] == 3:
			var enemy = DEFALT_ENEMY_3.instantiate()
			enemy.hp_enemy += WaveGeneration.how_many_hp_plus_enemy(LevelManager.count_level)
			enemy.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
			LevelManager.first_level_links_on_objects[count/6][count%6] = enemy
			game_objects.add_child(enemy)
		elif LevelManager.first_level_links_on_objects[count/6][count%6] == -1:
			var bonus_ball = BONUS_BALL.instantiate()
			bonus_ball.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
			LevelManager.first_level_links_on_objects[count/6][count%6] = bonus_ball
			game_objects.add_child(bonus_ball)
		elif LevelManager.first_level_links_on_objects[count/6][count%6] == -2:
			var skill_box = SKILL_BOX.instantiate()
			skill_box.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
			LevelManager.first_level_links_on_objects[count/6][count%6] = skill_box
			game_objects.add_child(skill_box)


# ЭТО ДЛЯ ТЕСТИРОВАНИЯ, ПОТОМ УДАЛИТЬ
func _on_button_pressed() -> void:
	LevelManager.player_balls = [1]
	_on_start_again_pressed()

func _on_button_2_pressed() -> void:
	LevelManager.player_balls = [2]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_3_pressed() -> void:
	LevelManager.player_balls = [1, 1, 1, 1, 3]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_4_pressed() -> void:
	LevelManager.player_balls = [4]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _chose_ball_button_pressed():
	game_state = PAUSE
	$UI/Chose_ball.visible = true
