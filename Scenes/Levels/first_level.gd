extends Node2D

enum {
	PLAY,
	BALLS_GO,
	LOSE,
	WIN
}

var game_state = PLAY
@export var bullet : PackedScene
@onready var count_bullet_label = $Start_bullet_position/Count_bullet_label
@onready var end_game_UI = $UI/End_game
@onready var end_game_UI_win = $UI/End_game/Win
@onready var end_game_UI_lose = $UI/End_game/Lose
@onready var raycast_detection_walls = $Start_bullet_position/Detection_walls
@onready var line = $Start_bullet_position/Line2D
@onready var start_balls_position = $Start_bullet_position/Start_bullet_position
@onready var strelka = $Start_bullet_position/Strelka
@onready var bullet_rotate_UI = $Start_bullet_position/Ball_rotate_UI
var old_coord_mouse : Vector2 = Vector2.ZERO
var cout_bullet = LevelManager.count_ball
var direction = Vector2.ZERO
var balls_can_go = true
var new_position_balls = Vector2.ZERO

func _ready() -> void:
	count_bullet_label.text = "x" + str(cout_bullet)
	#YandexSDK.gameplay_started()

func _process(delta):
	match game_state:
		PLAY:
			play_game()
		LOSE:
			lose()
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
	for child in $Enemy.get_children():
		if "enemy" in child.name:
			boss_alive = true
			break
	if boss_alive == false:
		game_state = WIN

	for child in get_children():
		if "CharacterBody2D" in child.name or "Bullet" in child.name:
			chec_lose_game = false
			break
	if chec_lose_game and boss_alive and count_bullet_label.text == "x0" and !balls_can_go:
		balls_can_go = true
		cout_bullet = LevelManager.count_ball
		count_bullet_label.text = "x" + str(cout_bullet)
		count_bullet_label.position.x += new_position_balls
		raycast_detection_walls.position.x += new_position_balls
		start_balls_position.position.x += new_position_balls
		#game_state = LOSE

func win():
	end_game_UI.visible = true
	end_game_UI_win.visible = true
	end_game_UI_lose.visible = false

func lose():
	end_game_UI.visible = true
	end_game_UI_win.visible = false
	end_game_UI_lose.visible = true

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

	if "enemy" in bullet_rotate_UI.collider_name:
		var colider_walls = raycast_detection_walls.get_collider()
		var colider_walls_point = raycast_detection_walls.get_collision_point()
		line.points[1] = colider_walls_point
	else:
		line.points[1] = bullet_rotate_UI.position

	if (start_balls_position.position.distance_to(strelka.points[1])) > (start_balls_position.position.distance_to(bullet_rotate_UI.position)):
		strelka.points[1] = bullet_rotate_UI.position
		line.visible = false

func balls_go() -> void:
	line.visible = false
	strelka.visible = false
	bullet_rotate_UI.visible = false
	balls_can_go = false

	for i in range(cout_bullet + 1):
		var b = bullet.instantiate()
		b.position = start_balls_position.position
		b.direction_bullet = direction
		get_tree().current_scene.add_child(b)
		count_bullet_label.text = "x" + str(cout_bullet - (i))
		await get_tree().create_timer(0.1).timeout

func _on_area_2d_body_entered(body: Node2D) -> void:
	if ("CharacterBody2D" in body.name or "Bullet" in body.name) and count_bullet_label.text == "x0":
		new_position_balls = body.position.x
		if new_position_balls > start_balls_position.position.x:
			new_position_balls = new_position_balls - start_balls_position.position.x
		else:
			new_position_balls = -(start_balls_position.position.x - new_position_balls)
		body.queue_free()
