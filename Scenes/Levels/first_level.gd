extends Node2D

enum {
	PLAY,
	BALLS_GO,
	WIN
}

var game_state = PLAY

var DEFALT_ENEMY = preload("res://Scenes/Enemy/Defalt_enemy.tscn")
var BONUS_BALL = preload("res://Scenes/Levels/bonus_ball.tscn")

@export var bullet : PackedScene
@onready var end_game_UI = $UI/End_game
@onready var end_game_UI_win = $UI/End_game/Win
@onready var game_objects = $Game_objects

@onready var count_bullet_label = $Dicariations/Start_bullet_position/Count_bullet_label
@onready var raycast_detection_walls = $Dicariations/Start_bullet_position/Detection_walls
@onready var line = $Dicariations/Start_bullet_position/Line2D
@onready var start_balls_position = $Dicariations/Start_bullet_position/Start_bullet_position
@onready var strelka = $Dicariations/Start_bullet_position/Strelka
@onready var bullet_rotate_UI = $Dicariations/Start_bullet_position/Ball_rotate_UI

var old_coord_mouse : Vector2 = Vector2.ZERO
var cout_bullet = LevelManager.count_ball
var direction = Vector2.ZERO
var balls_can_go = true
var new_position_balls = Vector2.ZERO

var first_level =  [[1, 1, 2, 1, 1, 2],[2, 1, 1, 1, 1, 1],[1, 1, 1, 2, 1, 2],[2, 1, 2, 0, 1, 0],[1, 0, 0, 0, 0, 0],[2, 0, 1, 0, 0, 1],[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0]]
var first_level_links = [[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0]]

func _ready() -> void:
	spawn_objects_on_matrix(1)
	count_bullet_label.text = "x" + str(cout_bullet)
	#YandexSDK.gameplay_started()

func _process(delta):
	match game_state:
		PLAY:
			play_game()
		WIN:
			win()

func play_game():
	if Input.is_action_pressed("LBM") and balls_can_go:
		if get_global_mouse_position() != old_coord_mouse:
			line.visible = true
			bullet_rotate_UI.visible = true
			strelka.visible = true
			direction = (get_global_mouse_position() - start_balls_position.position).normalized()
			if -2 <= rad_to_deg(direction.angle()) and rad_to_deg(direction.angle()) <= 90:
				direction = Vector2.from_angle(deg_to_rad(-2))
			elif 90 <= rad_to_deg(direction.angle()) and rad_to_deg(direction.angle()) >= -178:
				direction = Vector2.from_angle(deg_to_rad(-178))
			old_coord_mouse = get_global_mouse_position()
			draw_trajectory()

	if Input.is_action_just_released("LBM") and balls_can_go:
		balls_go()

	chec_game_end()

func chec_game_end():
	var chec_lose_game = true
	var boss_alive = false
	for child in game_objects.get_children():
		if child.has_method("enemy"):
			boss_alive = true
			break
	if boss_alive == false:
		game_state = WIN

	for child in get_children():
		if "CharacterBody2D" in child.name or "ball" in child.name:
			chec_lose_game = false
			break

	if chec_lose_game and boss_alive and count_bullet_label.text == "x0" and !balls_can_go:
		balls_can_go = true
		cout_bullet = LevelManager.count_ball
		count_bullet_label.text = "x" + str(cout_bullet)
		count_bullet_label.position.x += new_position_balls
		raycast_detection_walls.position.x += new_position_balls
		start_balls_position.position.x += new_position_balls
		
		for i in game_objects.get_children():
			i.position.y += 103

		for i in first_level_links.slice(7, 8):
			for j in i:
				if j != null and typeof(j) != 2:
					j.queue_free()

		first_level = first_level.slice(0, 7)
		first_level_links = first_level_links.slice(0, 7)
		first_level_links.insert(0, [1, 2, 1, 2, 1, 2])
		first_level.insert(0, [1, 2, 1, 2, 1, 2])
		spawn_objects_on_matrix()

func win():
	end_game_UI.visible = true
	end_game_UI_win.visible = true

func _on_start_again_pressed() -> void:
	LevelManager.count_ball = 10
	get_tree().reload_current_scene()

func draw_trajectory() -> void:
	strelka.points[0] = start_balls_position.position
	strelka.points[1] = start_balls_position.position + (direction * 100)
	line.points[0] = start_balls_position.position + (direction * 100)
	bullet_rotate_UI.position = start_balls_position.position
	bullet_rotate_UI.direction_bullet = direction
	bullet_rotate_UI.stop = false
	raycast_detection_walls.target_position = direction * 1000
	raycast_detection_walls.force_raycast_update()

	while !bullet_rotate_UI.stop:
		bullet_rotate_UI.ball_go()

	if (start_balls_position.position.distance_to(strelka.points[1])) > (start_balls_position.position.distance_to(bullet_rotate_UI.position)):
		strelka.points[1] = bullet_rotate_UI.position
		line.points[0] = bullet_rotate_UI.position

	if "enemy" in bullet_rotate_UI.collider_name or "StaticBody" in bullet_rotate_UI.collider_name:
		line.points[1] = raycast_detection_walls.get_collision_point()
	else:
		line.points[1] = bullet_rotate_UI.position

func balls_go() -> void:
	line.visible = false
	strelka.visible = false
	bullet_rotate_UI.visible = false
	balls_can_go = false

	for i in range(cout_bullet):
		var b = bullet.instantiate()
		b.position = start_balls_position.position
		b.direction_bullet = direction
		get_tree().current_scene.add_child(b)
		count_bullet_label.text = "x" + str(cout_bullet - (i+1))
		await get_tree().create_timer(0.07).timeout

func _on_area_2d_body_entered(body: Node2D) -> void:
	if ("CharacterBody2D" in body.name or "ball" in body.name):
		new_position_balls = body.position.x
		if new_position_balls > start_balls_position.position.x:
			new_position_balls = new_position_balls - start_balls_position.position.x
		else:
			new_position_balls = -(start_balls_position.position.x - new_position_balls)
		body.queue_free()

func spawn_objects_on_matrix(inex: int = 100) -> void:
	var count = -1
	if inex == 1:
		for i in first_level:
			for j in i:
				count += 1
				spawn_objects_by_index(count)
	else:
		for i in first_level[0]:
			count += 1
			spawn_objects_by_index(count)

func spawn_objects_by_index(count) -> void:
	if first_level[count/6][count%6] == 1:
		var enemy = DEFALT_ENEMY.instantiate()
		enemy.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
		first_level_links[count/6][count%6] = enemy
		game_objects.add_child(enemy)
	elif first_level[count/6][count%6] == 2:
		var bonus_ball = BONUS_BALL.instantiate()
		bonus_ball.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
		first_level_links[count/6][count%6] = bonus_ball
		game_objects.add_child(bonus_ball)
