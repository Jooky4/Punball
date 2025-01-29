extends Node2D

enum {
	PLAY,
	WIN,
	LOSE,
	PAUSE
}

var game_state = PLAY

var hp_player = LevelManager.hp_player
@onready var hp_player_bar = $Dicariations/Start_bullet_position/Start_bullet_position/Player_hp_bar
@onready var hp_player_label = $Dicariations/Start_bullet_position/Start_bullet_position/Player_hp_label

var DEFALT_ENEMY = preload("res://Scenes/Enemys/defalt_enemy.tscn")
var BONUS_BALL = preload("res://Scenes/Levels/bonus_ball.tscn")
var DEFALT_BALL = preload("res://Scenes/Balls/Defalt ball/defalt_ball.tscn")
var CRUNBLING_BALL = preload("res://Scenes/Balls/Сrumbling ball/crumbling_ball.tscn")
var BOMB_BALL = preload("res://Scenes/Balls/Bomb ball/bomb_ball.tscn")

@onready var end_game_UI = $UI/End_game
@onready var end_game_UI_win = $UI/End_game/Win
@onready var end_game_UI_lose = $UI/End_game/Lose
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
var balls_can_go = true
var new_position_balls = 0
var rignt_extreme_point
var left_extreme_point

func _ready() -> void:
	spawn_objects_on_matrix(1)
	count_ball_label.text = "x" + str(LevelManager.player_balls.size())
	count_level_label.text = str(LevelManager.count_level + 1)
	rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
	left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()
	hp_player_bar.max_value = hp_player
	hp_player_bar.value = hp_player
	hp_player_label.text = str(hp_player)
	#YandexSDK.gameplay_started()

func _process(delta):
	match game_state:
		PLAY:
			play_game()
		WIN:
			win()
		LOSE:
			lose()
		PAUSE:
			pause()

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

	chec_game_end()

func chec_game_end() -> void:
	var balls_on_map = true
	var boss_alive = false
	for child in game_objects.get_children():
		if child.has_method("enemy"):
			boss_alive = true
			break
	if boss_alive == false:
		game_state = WIN

	for child in get_children():
		if "CharacterBody2D" in child.name or "ball" in child.name:
			balls_on_map = false
			break

	if balls_on_map and boss_alive and count_ball_label.text == "x0" and !balls_can_go:
		balls_can_go = true
		count_ball_label.text = "x" + str(LevelManager.player_balls.size())
		start_balls_position.position.x += new_position_balls
		rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
		left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()

		for i in game_objects.get_children():
			i.position.y += 103

		LevelManager.apeend_new_balls()
		LevelManager.updete_last_line()
		count_level_label.text = str(LevelManager.count_level + 1)
		hp_player = LevelManager.hp_player
		if hp_player <= 0:
			game_state = LOSE
			hp_player_bar.value = 0
			hp_player_label.text = "0"
		else:
			hp_player_bar.value = hp_player
			hp_player_label.text = str(hp_player)
		spawn_objects_on_matrix()

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
	line.visible = false
	strelka.visible = false
	ball_rotate_UI.visible = false
	balls_can_go = false
	new_position_balls = 0

	for i in range(LevelManager.player_balls.size()):
		var ball
		if LevelManager.player_balls[i] == 1:
			ball = DEFALT_BALL.instantiate()
		elif LevelManager.player_balls[i] == 2:
			ball = CRUNBLING_BALL.instantiate()
		elif LevelManager.player_balls[i] == 3:
			ball = BOMB_BALL.instantiate()
		ball.position = start_balls_position.position
		ball.direction_bullet = direction
		get_tree().current_scene.add_child(ball)
		count_ball_label.text = "x" + str(LevelManager.player_balls.size() - (i+1))
		await get_tree().create_timer(0.05).timeout

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
		for i in LevelManager.first_level:
			for j in i:
				count += 1
				spawn_objects_by_index(count)
	else:
		for i in LevelManager.first_level[0]:
			count += 1
			spawn_objects_by_index(count)

func spawn_objects_by_index(count) -> void:
	if LevelManager.first_level[count/6][count%6] == 1:
		var enemy = DEFALT_ENEMY.instantiate()
		enemy.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
		LevelManager.first_level_links_on_objects[count/6][count%6] = enemy
		game_objects.add_child(enemy)
	elif LevelManager.first_level[count/6][count%6] == -1:
		var bonus_ball = BONUS_BALL.instantiate()
		bonus_ball.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
		LevelManager.first_level_links_on_objects[count/6][count%6] = bonus_ball
		game_objects.add_child(bonus_ball)


# ЭТО ДЛЯ ТЕСТИРОВАНИЯ, ПОТОМ УДАЛИТЬ
func _on_button_pressed() -> void:
	LevelManager.player_balls = [1]
	_on_start_again_pressed()

func _on_button_2_pressed() -> void:
	LevelManager.player_balls = [2]
	_on_start_again_pressed()

func _on_button_3_pressed() -> void:
	LevelManager.player_balls = [3, 1, 1, 1, 1]
	_on_start_again_pressed()

func _chose_ball_button_pressed() -> void:
	game_state = PAUSE
	$UI/Chose_ball.visible = true
