extends Node2D

enum {
	PLAY,
	BALLS_GO,
	WIN,
	LOSE,
	CHOOSE_SKILL
}

var game_state = PLAY

@onready var hp_player_bar = $Dicariations/Start_bullet_position/Start_bullet_position/Player_hp_bar
@onready var hp_player_label = $Dicariations/Start_bullet_position/Start_bullet_position/Player_hp_label

var DEFALT_ENEMY = preload("res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.tscn")
var BLUEBERRIES_ENEMY = preload("res://Scenes/Enemys/All_enemys/Blueberries_enemy/blueberries_enemy.tscn")
var BOMB_ENEMY = preload("res://Scenes/Enemys/All_enemys/Bomb_enemy/bomb_enemy.tscn")
var MEDIC_ENEMY = preload("res://Scenes/Enemys/All_enemys/Medic_enemy/medic_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var SLIME_ENEMY = preload("res://Scenes/Enemys/All_enemys/Slime_enemy/slime_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var SMALL_SLIME_ENEMY = preload("res://Scenes/Enemys/All_enemys/Slime_small_enemy/slime_small_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var SHIELD_ENEMY = preload("res://Scenes/Enemys/All_enemys/Shield_enemy/shield_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var JUMPER_ENEMY = preload("res://Scenes/Enemys/All_enemys/Jumper_enemy/jumper_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var MAGICIAN_ENEMY = preload("res://Scenes/Enemys/All_enemys/Magician_enemy/magician_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var SERVANT_MAGICIAN_ENEMY = preload("res://Scenes/Enemys/All_enemys/Servant_magic_enemy/servant_magic_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var POISON_ENEMY = preload("res://Scenes/Enemys/All_enemys/Poison_enemy/poison_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var BERSERKER_ENEMY = preload("res://Scenes/Enemys/All_enemys/Berserker_enemy/berserker_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ
var FIRE_ELEMENTAL_ENEMY = preload("res://Scenes/Enemys/All_enemys/Fire_elemental_enemy/fire_elemental_enemy.tscn") # НА ПЕРВОЙ ЛОКАЦИИ ЕГО НЕ БУДЕТ, ПОТОМ УБРАТЬ

var BOSS_FIRST_LOCATION = preload("res://Scenes/Enemys/Bosses/First_location/boss_first_location.tscn")
var BONUS_BALL = preload("res://Scenes/Bonus/bonus_ball.tscn")
var SKILL_BOX = preload("res://Scenes/Bonus/skill_box.tscn")

var DEFALT_BALL = preload("res://Scenes/Balls/Defalt ball/defalt_ball.tscn")
var CRUNBLING_BALL = preload("res://Scenes/Balls/Crumbling ball/crumbling_ball.tscn")
var BOMB_BALL = preload("res://Scenes/Balls/Bomb ball/bomb_ball.tscn")
var FIRE_BALL = preload("res://Scenes/Balls/Fire_ball/fire_ball.tscn")
var FREEZING_BALL = preload("res://Scenes/Balls/Freezing ball/freezing_ball.tscn")
var FREEZING_BOMB_BALL = preload("res://Scenes/Balls/Freezing bomb ball/freezing_bomb_ball.tscn")
var LIGHTNING_BALL = preload("res://Scenes/Balls/Lightning ball/lightning_ball.tscn")
var LASER_BALL = preload("res://Scenes/Balls/Laser ball/laser_ball.tscn")
var ROCKET_BALL = preload("res://Scenes/Balls/Rocket ball/rocket_ball.tscn")
var CUMULATIVE_BALL = preload("res://Scenes/Balls/Cumulative ball/cumulative_ball.tscn")
var KILLER_BALL = preload("res://Scenes/Balls/Killer ball/killer_ball.tscn")
var DRILLING_BALL = preload("res://Scenes/Balls/Drilling ball/drilling_ball.tscn")
var BACKSTABBING_BALL = preload("res://Scenes/Balls/Backstabbing ball/backstabbing_ball.tscn")

@onready var end_game_UI_win = $UI/Win
@onready var end_game_UI_lose = $UI/Lose
@onready var pause_menu_UI = $UI/Pause_menu_UI
@onready var pause_button = $UI/Button_Pause
@onready var choose_skill_UI = $UI/Get_skill_UI
@onready var combo_count_label = $UI/Combo_count
@onready var count_experience_label = $UI/Count_experience
@onready var experience_texture = $UI/Count_experience/Count_experience_texture/Experience_texture
@onready var get_count_experience_label = $UI/Count_experience/Get_cout_experience
@onready var balls_back_button = $UI/Balls_back_button
@onready var notification_about_boss_animation = $UI/Reminder_boss/AnimationPlayer
var count_get_experience_on_wave = 0
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
var balls_can_go : bool = false
var new_position_balls = 0
var rignt_extreme_point : Vector2
var left_extreme_point : Vector2
var mouse_in_pause_button_area = false
var revavil_for_AD_or_crystal : bool = false

func _ready() -> void:
	get_tree().paused = false
	await get_tree().create_timer(0.05).timeout
	LevelManager.restert()
	LevelManager.player_balls = [1, 1, 1, 1]
	ChangeScene.normal_screen()
	spawn_objects_on_matrix()
	count_ball_label.text = "x" + str(LevelManager.player_balls.size())
	count_level_label.text = str(LevelManager.count_level + 1)
	count_experience_label.text = str(LevelManager.count_experiance)
	rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
	left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()
	hp_player_bar.max_value = LevelManager.max_hp_player
	hp_player_bar.value = LevelManager.hp_player
	hp_player_label.text = str(LevelManager.hp_player)
	await get_tree().create_timer(0.8).timeout
	AudioManager.enemy_spawn()
	await get_tree().create_timer(0.3).timeout
	balls_can_go = true
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
		CHOOSE_SKILL:
			pause_button.disabled = true
			count_experience_label.text = str(LevelManager.count_experiance)
			if LevelManager.spin_skill == 0 or LevelManager.spin_skill < 0:
				count_experience_label.text = str(LevelManager.count_experiance)
				hp_player_bar.max_value = LevelManager.max_hp_player
				hp_player_bar.value = LevelManager.hp_player
				hp_player_label.text = str(LevelManager.hp_player)
				LevelManager.apeend_new_balls()
				count_ball_label.text = "x" + str(LevelManager.player_balls.size())
				balls_can_go = true
				pause_button.disabled = false
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

	if Input.is_action_just_released("LBM") and balls_can_go and mouse_in_pause_button_area == false:
		balls_go()

func chec_game_end() -> void:
	hp_player_bar.value = LevelManager.hp_player
	hp_player_label.text = str(LevelManager.hp_player)
	var balls_on_map = true
	var boss_alive = false
	if LevelManager.combo_count > combo_count:
		combo_count_label.visible = true
		combo_count_label.text = str(LevelManager.combo_count)
		combo_count_label.scale = Vector2(1.5, 1.5)
		combo_count = LevelManager.combo_count
	else:
		if combo_count_label.scale > Vector2(1, 1):
			combo_count_label.scale -= Vector2(0.05, 0.05)

	for child in game_objects.get_children():
		if child.has_method("boss"):
			if child.alive:
				boss_alive = true
			break
	if LevelManager.boss_on_map == true and boss_alive == false and LevelManager.count_level > WaveGeneration.get_count_wave_on_location() - 2:
		game_state = WIN
		return
	else:
		boss_alive = true

	for child in self.get_children():
		if child.has_method("ball"):
			balls_on_map = false
			break

	if balls_on_map and boss_alive and count_ball_label.text == "x0" and !balls_can_go:
		end_wave()

func get_expirians_animation(experience) -> void:
	get_count_experience_label.visible = true
	experience_texture.scale = Vector2(1, 1)
	get_count_experience_label.scale = Vector2(1, 1)
	var tween = get_tree().create_tween()
	tween.tween_property(experience_texture, "scale", Vector2(1.2, 1.2), 0.05)
	tween.chain().tween_property(experience_texture, "scale", Vector2(1, 1), 0.05)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(get_count_experience_label, "scale", Vector2(1.2, 1.2), 0.05)
	tween1.chain().tween_property(get_count_experience_label, "scale", Vector2(1, 1), 0.05)
	count_get_experience_on_wave += experience
	get_count_experience_label.text = "+"+str(count_get_experience_on_wave)
	LevelManager.count_experiance += experience
	count_experience_label.text = str(LevelManager.count_experiance)
	var count_bank = 0
	for i in self.get_children():
		if i != null:
			if i.has_method("bank_with_experience"):
				if i.bank_go:
					count_bank += 1
	if count_bank == 1 or count_bank == 0:
		await get_tree().create_timer(0.75).timeout
		get_count_experience_label.visible = false

func get_health(health_hp) -> void:
	LevelManager.hp_player += health_hp
	if LevelManager.hp_player > LevelManager.max_hp_player:
		LevelManager.hp_player = LevelManager.max_hp_player
	hp_player_bar.value = LevelManager.hp_player
	hp_player_label.text = str(LevelManager.hp_player)

func win() -> void:
	PlayerIndicatorsManager.update_count_max_wave(WaveGeneration.count_wave_on_locations[WaveGeneration.current_location])
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/Win_Lose_UI/win_lose_UI.tscn")

func lose() -> void:
	if revavil_for_AD_or_crystal == false:
		end_game_UI_lose.visible = true
		end_game_UI_lose.update_count_cristal()
	else:
		if LevelManager.boss_on_map:
			PlayerIndicatorsManager.update_count_max_wave(WaveGeneration.count_wave_on_locations[WaveGeneration.current_location] - 1)
		else:
			PlayerIndicatorsManager.update_count_max_wave(LevelManager.count_level + 1)
		get_tree().change_scene_to_file("res://Scenes/UI/Win_Lose_UI/win_lose_UI.tscn")

func revavil_player(for_AD_or_crystal : bool = false):
	end_game_UI_lose.visible = false
	hp_player_bar.value = LevelManager.hp_player
	hp_player_label.text = str(LevelManager.hp_player)
	LevelManager.updete_last_line()
	spawn_objects_on_matrix()
	animation_bank_with_experience()
	animation_health()
	if LevelManager.boss_on_map:
		$UI/Boss_label.visible = true
		count_level_label.visible = false
	else:
		count_level_label.visible = true
		count_level_label.text = str(LevelManager.count_level + 1)
	LevelManager.delete_freezing_and_fire_on_enemy()

	if count_level_label.text == str(WaveGeneration.get_count_wave_on_location() - 1) and count_level_label.visible:
		notification_about_boss_animation.play("boss_close")
		await notification_about_boss_animation.animation_finished
	elif notification_about_boss_animation.current_animation == "spawn_boss":
		await notification_about_boss_animation.animation_finished
	if LevelManager.spin_skill != 0 and LevelManager.spin_skill > 0:
		choose_skill_UI.visible = true
		choose_skill_UI.get_number_skill(LevelManager.spin_skill)
		game_state = CHOOSE_SKILL
		return
	await get_tree().create_timer(0.05).timeout
	end_game_UI_lose.visible = false
	balls_can_go = true
	game_state = PLAY
	if for_AD_or_crystal == true:
		revavil_for_AD_or_crystal = true

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
		line.visible = false
		strelka.visible = false
		ball_rotate_UI.visible = false
		new_position_balls = 0
		game_state = BALLS_GO

		for i in range(LevelManager.player_balls.size()):
			var ball
			match LevelManager.player_balls[i]:
				1:
					ball = DEFALT_BALL.instantiate()
				2:
					ball = CRUNBLING_BALL.instantiate()
				3:
					ball = BOMB_BALL.instantiate()
				4:
					ball = FREEZING_BALL.instantiate()
				5:
					ball = LIGHTNING_BALL.instantiate()
				6:
					ball = FREEZING_BOMB_BALL.instantiate()
				7:
					ball = FIRE_BALL.instantiate()
				8:
					ball = LASER_BALL.instantiate()
					ball.line_damage = 0
				9:
					ball = LASER_BALL.instantiate()
					ball.line_damage = 1
				10:
					ball = ROCKET_BALL.instantiate()
				11:
					ball = CUMULATIVE_BALL.instantiate()
				12:
					ball = KILLER_BALL.instantiate()
				13:
					ball = DRILLING_BALL.instantiate()
				14:
					ball =  BACKSTABBING_BALL.instantiate()
			if i == 0 and "Суперначало" in LevelManager.player_skills:
				ball.damage_ball *= 3
			if i == (LevelManager.player_balls.size() - 1) and "Последний рывок" in LevelManager.player_skills:
				ball.damage_ball *= 3
			ball.position = start_balls_position.position
			ball.direction_bullet = direction
			get_tree().current_scene.add_child(ball)
			count_ball_label.text = "x" + str(LevelManager.player_balls.size() - (i+1))
			AudioManager.ball_spawn()
			await get_tree().create_timer(0.1).timeout
	balls_back_button.position = start_balls_position.position + Vector2(0, -100)
	balls_back_button.visible = true

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

func spawn_objects_on_matrix() -> void:
	var count = -1
	for i in LevelManager.first_level_links_on_objects:
		for j in i:
			count += 1
			spawn_objects_by_index(count)
	await get_tree().create_timer(1.1).timeout
	LevelManager.check_traps()

func spawn_objects_by_index(count, multiplier_stats : float = 1) -> void:
	if typeof(LevelManager.first_level_links_on_objects[count/6][count%6]) == 2:
		var buff
		var count_wave = LevelManager.count_level
		if LevelManager.boss_on_map:
			count_wave = WaveGeneration.get_count_wave_on_location() - 2

		match LevelManager.first_level_links_on_objects[count/6][count%6]:
			-2: buff = SKILL_BOX.instantiate()
			-1: buff = BONUS_BALL.instantiate()
			1: 
				buff = DEFALT_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(1)
			2: 
				buff = BLUEBERRIES_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) * 0.8
				buff.player_damage = WaveGeneration.how_many_damage_player(2)
			3: 
				buff = BOMB_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(3)
			4: 
				buff = BOSS_FIRST_LOCATION.instantiate()
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6)] = buff
				LevelManager.first_level_links_on_objects[(count/6)][(count%6) + 1] = buff
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6) + 1] = buff
				buff.hp_enemy = (WaveGeneration.how_many_hp_plus_enemy(count_wave - 1) * 0.8) * 9
				buff.player_damage = WaveGeneration.how_many_damage_player(2) * 2
				LevelManager.boss_on_map = true
				$UI/Boss_label.visible = true
				count_level_label.visible = false
				notification_about_boss_animation.play("spawn_boss")
			5: 
				buff = MEDIC_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) * 0.6
				buff.player_damage = WaveGeneration.how_many_damage_player(5)
			6: 
				buff = SLIME_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(6)
			7: 
				buff = SMALL_SLIME_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) / 2
				buff.player_damage = WaveGeneration.how_many_damage_player(7) / 2
			8:
				buff = SHIELD_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(8)
			9:
				buff = JUMPER_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(9)
			10:
				buff = MAGICIAN_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) * 0.6
				buff.player_damage = WaveGeneration.how_many_damage_player(10)
			11:
				buff = SERVANT_MAGICIAN_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) / 4
				buff.player_damage = WaveGeneration.how_many_damage_player(11) / 4
			12:
				buff = POISON_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(12)
			13:
				buff = BERSERKER_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(13)
			14:
				buff = FIRE_ELEMENTAL_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) * 0.8
				buff.player_damage = WaveGeneration.how_many_damage_player(14)

		if LevelManager.boss_on_map:
			buff.hp_enemy *= WaveGeneration.get_coef_hp_enemy_when_boss_on_map()

		buff.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
		LevelManager.first_level_links_on_objects[count/6][count%6] = buff
		game_objects.add_child(buff)

func end_wave() -> void:
	LevelManager.apeend_new_balls()
	balls_back_button.visible = false
	count_ball_label.text = "x" + str(LevelManager.player_balls.size())
	combo_count_label.visible = false
	combo_count = 0
	LevelManager.combo_count = 0
	combo_count_label.text = str(0)
	count_get_experience_on_wave = 0
	get_count_experience_label.text = ""
	start_balls_position.position.x += new_position_balls
	rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
	left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()
	animation_bank_with_experience()
	animation_health()
	LevelManager.moving_object(start_balls_position.position)
	if LevelManager.hit_player:
		await get_tree().create_timer(3).timeout
	else:
		await get_tree().create_timer(1).timeout
	if LevelManager.hp_player <= 0:
		if "Оживление" in LevelManager.player_skills:
			LevelManager.revival()
			hp_player_bar.value = LevelManager.hp_player
			hp_player_label.text = str(LevelManager.hp_player)
		else:
			hp_player_bar.value = 0
			hp_player_label.text = "0"
			game_state = LOSE
			return
	else:
		hp_player_bar.value = LevelManager.hp_player
		hp_player_label.text = str(LevelManager.hp_player)
	LevelManager.updete_last_line()
	spawn_objects_on_matrix()
	animation_bank_with_experience()
	animation_health()
	if LevelManager.boss_on_map:
		$UI/Boss_label.visible = true
		count_level_label.visible = false
	else:
		count_level_label.visible = true
		count_level_label.text = str(LevelManager.count_level + 1)
	LevelManager.delete_freezing_and_fire_on_enemy()

	if count_level_label.text == str(WaveGeneration.get_count_wave_on_location() - 1) and count_level_label.visible:
		notification_about_boss_animation.play("boss_close")
		await notification_about_boss_animation.animation_finished
	elif notification_about_boss_animation.current_animation == "spawn_boss":
		await notification_about_boss_animation.animation_finished
	if LevelManager.spin_skill != 0:
		choose_skill_UI.visible = true
		choose_skill_UI.get_number_skill(LevelManager.spin_skill)
		game_state = CHOOSE_SKILL
		return
	balls_can_go = true
	game_state = PLAY

func animation_bank_with_experience() -> void:
	for i in self.get_children():
		if i != null:
			if i.has_method("bank_with_experience"):
				if !i.bank_go:
					i.go_to_count()
					await get_tree().create_timer(0.1).timeout

func animation_health() -> void:
	for i in self.get_children():
		if i != null:
			if i.has_method("health"):
				if !i.health_go:
					i.go_to_player(start_balls_position.position)
					await get_tree().create_timer(0.1).timeout

func _on_balls_back_pressed() -> void:
	balls_back_button.visible = false
	for child in self.get_children():
		if child.has_method("ball"):
			child.return_to_player(start_balls_position.position)

func _on_button_pause_pressed() -> void:
	AudioManager.click()
	pause_menu_UI.update_texture_skill()
	pause_menu_UI.visible = true
	get_tree().paused = true
	Engine.time_scale = 0

# ЭТО ДЛЯ ТЕСТИРОВАНИЯ, ПОТОМ УДАЛИТЬ
func _chose_ball_button_pressed():
	$UI/Chose_ball.visible = true
