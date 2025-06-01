extends Node2D

enum State {
	PLAY,
	BALLS_GO,
	WIN,
	LOSE,
	CHOOSE_SKILL
}

var game_state: State = State.PLAY

var PIM = PlayerIndicatorsManager

@onready var hp_player_bar = $Dicariations/Start_bullet_position/Start_bullet_position/Player_hp_bar
@onready var hp_player_label = $Dicariations/Start_bullet_position/Start_bullet_position/Player_hp_label

var DEFALT_ENEMY = preload("res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.tscn")

# Эти враги подгружаются по необходимости
var BLUEBERRIES_ENEMY = null
var BOMB_ENEMY = null
var MEDIC_ENEMY = null
var SLIME_ENEMY = null
var SMALL_SLIME_ENEMY = null
var SHIELD_ENEMY = null
var JUMPER_ENEMY = null
var MAGICIAN_ENEMY = null
var SERVANT_MAGICIAN_ENEMY = null
var POISON_ENEMY = null
var BERSERKER_ENEMY = null
var FIRE_ELEMENTAL_ENEMY = null

var BONUS_BALL = preload("res://Scenes/Bonus/bonus_ball.tscn")
var SKILL_BOX = preload("res://Scenes/Bonus/skill_box.tscn")

var DEFALT_BALL_1_CHARACTER = preload("res://Scenes/Balls/Defalt ball/defalt_ball.tscn")
var DEFALT_BALL_2_CHARACTER = preload("res://Scenes/Balls/Character_balls/character_2_ball.tscn")
var DEFALT_BALL_3_CHARACTER = preload("res://Scenes/Balls/Character_balls/character_3_ball.tscn")

var CRUNBLING_BALL = preload("res://Scenes/Balls/Crumbling ball/crumbling_ball.tscn")
var BOMB_BALL = null
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

@onready var end_game_UI_lose = $UI/Lose
@onready var pause_menu_UI = $UI/Pause_menu_UI
@onready var pause_button = $UI/Button_Pause
@onready var choose_skill_UI = $UI/Get_skill_UI

@onready var count_experience_label = $UI/Count_experience
@onready var experience_texture = $UI/Count_experience/Count_experience_texture/Experience_texture
@onready var get_count_experience_label = $UI/Count_experience/Get_cout_experience
@onready var balls_back_button = $UI/Balls_back_button
@onready var notification_about_boss_animation = $UI/Reminder_boss/AnimationPlayer
var count_get_experience_on_wave = 0
var end_wave_bool : bool = false
var notification_about_boss_close : bool = false
var revaving_from_skill : bool = false

@onready var game_objects = $Game_objects

@onready var count_level_label = $UI/Count_level_label

@onready var count_ball_label = $Dicariations/Start_bullet_position/Start_bullet_position/Count_bullet_label
@onready var raycast_detection_walls = $Dicariations/Start_bullet_position/Start_bullet_position/Detection_walls
@onready var line = $Dicariations/Start_bullet_position/Line2D
@onready var start_balls_position = $Dicariations/Start_bullet_position/Start_bullet_position
@onready var strelka = $Dicariations/Start_bullet_position/Strelka
@onready var ball_rotate_UI = $Dicariations/Start_bullet_position/Ball_rotate_UI
@onready var character_anim = $Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Alisa
@onready var camera = $Camera2D


var old_coord_mouse : Vector2 = Vector2.ZERO
var direction = Vector2.ZERO
var balls_can_go : bool = false
var new_position_balls = 0
var rignt_extreme_point : Vector2
var left_extreme_point : Vector2
var mouse_in_pause_button_area = false
var revavil_for_AD_or_crystal : bool = false
var kill_on_wave : int = 0

var is_boss_dead: bool = false
var experience_object_list: Array
var heal_object_list: Array

# нужно для проверки был ли показан туториал со скилом (для вызова метрики)
var skill_tutorial_was_shown: bool = false
var skill_tutorial_was_shown_on_level: int = -1


func _set_state(value: State) -> void:
	#if OS.is_debug_build():
		#prints("change state from", game_state, "to", value)

	game_state = value

	match game_state:
		State.PLAY:
			balls_can_go = true
			pause_button.disabled = false
			count_experience_label.text = str(LevelManager.count_experiance)
		State.WIN:
			win()
		State.LOSE:
			lose()
		State.CHOOSE_SKILL:
			balls_can_go = false
			pause_button.disabled = true
			count_experience_label.text = str(LevelManager.count_experiance)


func _ready() -> void:
	YandexSDK.connect("interstitial_ad", star_location)
	Engine.time_scale = 1
	get_tree().paused = false
	update_location_image()

	# Metrika
	var current_level = LevelManager.count_level
	var current_location = 1 + WaveGeneration.get_current_location()
	if current_location >= 1:
		YandexMetrika.ym(101336789,'reachGoal','started_location_%d' % current_location)
	if WaveGeneration.get_current_location() == -1:
		YandexMetrika.ym(101336789,'reachGoal','started_location_%d' % 10)

	update_character()
	check_tutorial()

	await Utils.timeout(0.05)

	count_ball_label.text = "x" + str(LevelManager.player_balls.size())
	hp_player_bar.max_value = LevelManager.max_hp_player
	update_character_label()
	if PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL >= 1:
		LevelManager.spin_skill = 1
		choose_skill_UI.visible = true
		choose_skill_UI.get_number_skill(-1)
	while LevelManager.spin_skill == 1:
		await Utils.timeout(0.1)

	$UI/Button.disabled = false
	LevelManager.apeend_new_balls()
	spawn_objects_on_matrix()
	count_ball_label.text = "x" + str(LevelManager.player_balls.size())
	count_level_label.text = str(LevelManager.count_level + 1)
	count_experience_label.text = str(LevelManager.count_experiance)
	rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
	left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()
	hp_player_bar.max_value = LevelManager.max_hp_player
	update_character_label()
	YandexSDK.gameplay_started()

	await Utils.timeout(0.8)
	AudioManager.enemy_spawn()
	await Utils.timeout(0.3)
	balls_can_go = true


func star_location(result) -> void:
	if result == "closed" or result == "error":
		AudioServer.set_bus_mute(0, false)
		AudioManager.music_start()
		YandexSDK.gameplay_started()

func check_tutorial() -> void:
	if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 0 and WaveGeneration.current_location == 1:
		$Tutorial.visible = true
		$Tutorial/Label.visible = true
		$Tutorial/Control.visible = true
	else:
		$Tutorial.visible = false


func update_location_image() -> void:
	var location = (WaveGeneration.current_location % 10) - 1

	if location == -1:
		%LevelBackground.set_background(9)
	else:
		%LevelBackground.set_background(location)


# TODO: грузить только используемого персонажа вместо удаления неиспользуемых
func update_character() -> void:
	match PlayerIndicatorsManager.CURRENT_CHARACTER:
		1:
			character_anim = $Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Alisa
			$Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Merlin.queue_free()
			$Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Busya.queue_free()
		2:
			character_anim = $Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Merlin
			$Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Alisa.queue_free()
			$Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Busya.queue_free()
		3:
			character_anim = $Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Busya
			$Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Alisa.queue_free()
			$Dicariations/Start_bullet_position/Start_bullet_position/Chatacter/Merlin.queue_free()


func _process(delta):
	match game_state:
		State.PLAY:
			_get_input()
		State.BALLS_GO:
			check_game_end()


func _get_input() -> void:
	if Constants.CHEATS_ENABLED:
		if Input.is_action_just_pressed("DEBUG_END_LEVEL"):
			_set_state(State.WIN)

		if Input.is_action_just_pressed("DEBUG_SMALL_DAMAGE_ALL"):
			for i in game_objects.get_children():
				if i.has_method("deal_damage"):
					i.deal_damage(100, Color.CRIMSON)

		if Input.is_action_just_pressed("DEBUG_DAMAGE_ALL"):
			for i in game_objects.get_children():
				if i.has_method("deal_damage"):
					i.deal_damage(1000, Color.CRIMSON)

		if Input.is_action_just_pressed("DEBUG_INC_WAVE"):
			LevelManager.count_level += 1
			count_level_label.text = str(LevelManager.count_level + 1)

	if Input.is_action_pressed("LBM") and balls_can_go:
		if get_global_mouse_position() != old_coord_mouse:
			$Tutorial.visible = false
			$Tutorial/Control.visible = false
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
		AudioServer.set_bus_mute(0, false)
		$Tutorial/Label.visible = false
		balls_go()


func check_game_end() -> void:
	update_character_label()

	if !end_wave_bool:
		var balls_on_map = true

		for child in self.get_children():
			if child.has_method("ball"):
				balls_on_map = false
				break

		# TODO: разобраться почему проверяется текст лейбла count_ball_label а не значение
		if balls_on_map and count_ball_label.text == "x0" and !balls_can_go:
			end_wave_bool = true
			await Utils.timeout(1)
			end_wave()


func get_expirians_animation(experience) -> void:
	if kill_on_wave > 0:
		get_count_experience_label.visible = true
		experience_texture.scale = Vector2(1, 1)
		get_count_experience_label.scale = Vector2(1, 1)
		var tween = get_tree().create_tween()
		tween.tween_property(experience_texture, "scale", Vector2(1.2, 1.2), 0.05)
		tween.chain().tween_property(experience_texture, "scale", Vector2(1, 1), 0.05)
		var tween1 = get_tree().create_tween()
		tween1.tween_property(get_count_experience_label, "scale", Vector2(1.2, 1.2), 0.05)
		tween1.chain().tween_property(get_count_experience_label, "scale", Vector2(1, 1), 0.05)
		count_get_experience_on_wave += round((25 * ((kill_on_wave * (kill_on_wave + 1)) / 2)) / kill_on_wave)
		if count_get_experience_on_wave >= 25 * ((kill_on_wave * (kill_on_wave + 1)) / 2):
			count_get_experience_on_wave = 25 * ((kill_on_wave * (kill_on_wave + 1)) / 2)
		get_count_experience_label.text = "+"+str(count_get_experience_on_wave)
		count_experience_label.text = str(LevelManager.count_experiance)
		var count_bank = 0
		for i in self.get_children():
			if i != null:
				if i.has_method("bank_with_experience"):
					if i.bank_go:
						count_bank += 1
		if count_bank == 1 or count_bank == 0:
			count_get_experience_on_wave = 25 * ((kill_on_wave * (kill_on_wave + 1)) / 2)
			await get_tree().create_timer(0.75).timeout
			get_count_experience_label.visible = false

func get_health(health_hp) -> void:
	LevelManager.hp_player += round(health_hp)
	LevelManager.hp_player = round(LevelManager.hp_player)
	if LevelManager.hp_player > LevelManager.max_hp_player:
		LevelManager.hp_player = LevelManager.max_hp_player
	update_character_label()
	if round(health_hp) > 0:
		player_take_damage_create_label("+" + str(roundi(health_hp)), 0)
	if PlayerIndicatorsManager.CURRENT_CHARACTER == 3:
		LevelManager.update_character_3_damage_from_OZ()

func player_take_damage_create_label(label_damage, who_deal_damage : int = 0) -> void:
	var color_label = ElementsManager.color_elements["FIRE"]
	var label = ObjectPool.get_object("enemy_damage_label")
	label.z_index = 8
	label.global_position = start_balls_position.global_position

	if typeof(label_damage) != TYPE_FLOAT and typeof(label_damage) != TYPE_INT:
		if "+" in label_damage:
			color_label = ElementsManager.color_elements["HEAL"]
			label.text = str(label_damage)
		else:
			label.global_position = start_balls_position.global_position + Vector2(-30, 0)
			color_label = ElementsManager.color_elements["NORMAL"]
			label.text = str(label_damage)
	else:
		label.text = "-" + str(label_damage)
		if who_deal_damage == 0:
			camera.small_shake(1.1)
		elif who_deal_damage == 1:
			camera.small_shake(0.75)
		elif who_deal_damage == 2:
			camera.small_shake(1.3)
			show_hit_effect()
		character_anim.damage()
		$Damage_Player.play()
	label.modulate = color_label
	label.scale = Vector2(0.2, 0.2)
	label.show_label2()
	update_character_label()

func show_hit_effect():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($UI/Damage, "color:a", 0.4, 0.1)
	tween.tween_property($UI/Damage, "color:a", 0.0, 0.7)


func win() -> void:
	# Metrika
	if WaveGeneration.get_current_location() == -1:
		YandexMetrika.ym(101336789,'reachGoal','completed_location_%d' % 10)
	else:
		var current_location = 1 + WaveGeneration.get_current_location()
		YandexMetrika.ym(101336789,'reachGoal','completed_location_%d' % current_location)

	PlayerIndicatorsManager.update_count_max_wave(WaveGeneration.get_count_wave_on_location())
	LevelManager.win_or_lose = "win"
	ChangeScene.to("win")


func lose() -> void:
	if revavil_for_AD_or_crystal == false:
		end_game_UI_lose.visible = true
		end_game_UI_lose.update_player_state()
	else:
		if LevelManager.boss_on_map:
			PlayerIndicatorsManager.update_count_max_wave(WaveGeneration.get_count_wave_on_location() - 1)
		else:
			PlayerIndicatorsManager.update_count_max_wave(LevelManager.count_level + 1)
		LevelManager.win_or_lose = "lose"
		ChangeScene.to("game_over")


func revavil_player(for_AD_or_crystal : bool = false):
	end_game_UI_lose.visible = false
	character_anim.alive()
	update_character_label()
	if PlayerIndicatorsManager.CURRENT_CHARACTER == 3:
		LevelManager.update_character_3_damage_from_OZ()
	LevelManager.updete_last_line()
	spawn_objects_on_matrix()
	if LevelManager.boss_on_map:
		$UI/Boss_label.visible = true
		count_level_label.visible = false
	else:
		count_level_label.visible = true
		count_level_label.text = str(LevelManager.count_level + 1)
	LevelManager.delete_freezing_and_fire_on_enemy()

	#check_boss_alive()
	if is_boss_dead:
		_set_state(State.WIN)
		return

	if count_level_label.text == str(WaveGeneration.get_count_wave_on_location() - 1) and count_level_label.visible and notification_about_boss_close == false:
		notification_about_boss_animation.play("boss_close")
		notification_about_boss_close = true
		await notification_about_boss_animation.animation_finished
	elif notification_about_boss_animation.current_animation == "spawn_boss":
		await notification_about_boss_animation.animation_finished
	LevelManager.kill_on_whis_wave = 0
	await get_tree().create_timer(0.05).timeout
	end_game_UI_lose.visible = false
	if LevelManager.spin_skill > 0:
		choose_skill_UI.visible = true
		choose_skill_UI.get_number_skill(LevelManager.spin_skill)

		_set_state(State.CHOOSE_SKILL)
		return

	if for_AD_or_crystal == true:
		revavil_for_AD_or_crystal = true

	_set_state(State.PLAY)


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
		end_wave_bool = false
		balls_can_go = false
		line.visible = false
		strelka.visible = false
		ball_rotate_UI.visible = false
		new_position_balls = 0
		character_anim.attack()
		_set_state(State.BALLS_GO)
		var count_time = 0

		for i in LevelManager.player_balls.size():
			var ball

			# TODO: заменить match на словарь мячей
			match LevelManager.player_balls[i]:
				1:
					if PlayerIndicatorsManager.CURRENT_CHARACTER == 1:
						ball = DEFALT_BALL_1_CHARACTER.instantiate()
					elif PlayerIndicatorsManager.CURRENT_CHARACTER == 2:
						ball = DEFALT_BALL_2_CHARACTER.instantiate()
					elif PlayerIndicatorsManager.CURRENT_CHARACTER == 3:
						ball = DEFALT_BALL_3_CHARACTER.instantiate()
				2:
					ball = CRUNBLING_BALL.instantiate()
				3:
					if BOMB_BALL == null:
						BOMB_BALL = load("res://Scenes/Balls/Bomb ball/bomb_ball.tscn")

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
			count_time += 0.1
			if count_time > 1:
				character_anim.pause()
	character_anim.not_pause()
	balls_back_button.position = start_balls_position.position + Vector2(0, -210)
	balls_back_button.visible = true
	if new_position_balls != 0:
		create_tween().tween_property(start_balls_position, "position", Vector2(start_balls_position.position.x + new_position_balls, start_balls_position.position.y), 1).set_trans(Tween.TRANS_QUAD)
		create_tween().tween_property(balls_back_button, "position", Vector2(start_balls_position.position.x + new_position_balls, balls_back_button.position.y), 1).set_trans(Tween.TRANS_QUAD)
		if new_position_balls > 0:
			character_anim.move_right()
		else:
			character_anim.move_left()
		await get_tree().create_timer(1.05).timeout
		character_anim.idle()
		rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
		left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()


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
				if balls_back_button.visible:
					create_tween().tween_property(start_balls_position, "position", Vector2(start_balls_position.position.x + new_position_balls, start_balls_position.position.y), 1).set_trans(Tween.TRANS_QUAD)
					create_tween().tween_property(balls_back_button, "position", Vector2(start_balls_position.position.x + new_position_balls, balls_back_button.position.y), 1).set_trans(Tween.TRANS_QUAD)
					if new_position_balls > 0:
						character_anim.move_right()
					else:
						character_anim.move_left()
					await get_tree().create_timer(1.05).timeout
					character_anim.idle()
					rignt_extreme_point = (Vector2(667, 1055) - start_balls_position.position).normalized()
					left_extreme_point = (Vector2(50, 1055) - start_balls_position.position).normalized()
			else:
				body.queue_free()

func spawn_objects_on_matrix() -> void:
	if is_boss_dead:
		return

	var count = -1
	for i in LevelManager.first_level_links_on_objects:
		for j in i:
			count += 1
			spawn_objects_by_index(count)

func spawn_objects_by_index(count, multiplier_stats : float = 1) -> void:
	if typeof(LevelManager.first_level_links_on_objects[count/6][count%6]) == 2:
		var buff
		var count_wave = LevelManager.count_level
		if LevelManager.boss_on_map:
			count_wave = WaveGeneration.get_count_wave_on_location() - 2
		notification_about_new_enemy(LevelManager.first_level_links_on_objects[count/6][count%6])
		var _current_obj_id = LevelManager.first_level_links_on_objects[count/6][count%6]
		match _current_obj_id:
			-2:
				buff = SKILL_BOX.instantiate()
				if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 0 and WaveGeneration.current_location == 1:
					show_skill_tutorial()
					skill_tutorial_was_shown = true
					skill_tutorial_was_shown_on_level = LevelManager.count_level
					PlayerIndicatorsManager.GAMEPLAY_TUTORIL = 1
					PlayerIndicatorsManager.update_player_date_on_server()

					YandexMetrika.ym(101336789,'reachGoal','complete_level_2_with_additional_ball_tutorial')
			-1:
				buff = BONUS_BALL.instantiate()
				if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 0 and WaveGeneration.current_location == 1:
					show_ball_tutorial()

					YandexMetrika.ym(101336789,'reachGoal','complete_level_1_with_shot_tutorial')
			1:
				buff = DEFALT_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(1)
			2:
				if BLUEBERRIES_ENEMY == null:
					BLUEBERRIES_ENEMY = load("res://Scenes/Enemys/All_enemys/Blueberries_enemy/blueberries_enemy.tscn")

				buff = BLUEBERRIES_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) * 0.8
				buff.player_damage = WaveGeneration.how_many_damage_player(2)
			3:
				if BOMB_ENEMY == null:
					BOMB_ENEMY = load("res://Scenes/Enemys/All_enemys/Bomb_enemy/bomb_enemy.tscn")

				buff = BOMB_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(3)
			4:
				buff = load("res://Scenes/Enemys/Bosses/Blieberries_boss/boss_first_location.tscn").instantiate()
				buff.died.connect(_on_boss_died)
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6)] = buff
				LevelManager.first_level_links_on_objects[(count/6)][(count%6) + 1] = buff
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6) + 1] = buff
				buff.hp_enemy = (WaveGeneration.how_many_hp_plus_enemy(count_wave - 1) * 0.8) * 9
				buff.player_damage = WaveGeneration.how_many_damage_player(2) * 2
				LevelManager.boss_on_map = true
				$UI/Boss_label.visible = true
				count_level_label.visible = false
				notification_about_boss_here()
			5:
				if MEDIC_ENEMY == null:
					MEDIC_ENEMY = load("res://Scenes/Enemys/All_enemys/Medic_enemy/medic_enemy.tscn")
				buff = MEDIC_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) * 0.6
				buff.player_damage = WaveGeneration.how_many_damage_player(5)
			6:
				if SLIME_ENEMY == null:
					SLIME_ENEMY = load("res://Scenes/Enemys/All_enemys/Slime_enemy/slime_enemy.tscn")

				buff = SLIME_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(6)
			7:
				if SMALL_SLIME_ENEMY == null:
					SMALL_SLIME_ENEMY = load("res://Scenes/Enemys/All_enemys/Slime_small_enemy/slime_small_enemy.tscn")

				buff = SMALL_SLIME_ENEMY.instantiate()
				buff.alive = false
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) / 2
				buff.player_damage = WaveGeneration.how_many_damage_player(7) / 2
			8:
				if SHIELD_ENEMY == null:
					SHIELD_ENEMY = load("res://Scenes/Enemys/All_enemys/Shield_enemy/shield_enemy.tscn")

				buff = SHIELD_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(8)
			9:
				if JUMPER_ENEMY == null:
					JUMPER_ENEMY = load("res://Scenes/Enemys/All_enemys/Jumper_enemy/jumper_enemy.tscn")

				buff = JUMPER_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(9)
			10:
				if MAGICIAN_ENEMY == null:
					MAGICIAN_ENEMY = load("res://Scenes/Enemys/All_enemys/Magician_enemy/magician_enemy.tscn")

				buff = MAGICIAN_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) * 0.6
				buff.player_damage = WaveGeneration.how_many_damage_player(10)
			11:
				if SERVANT_MAGICIAN_ENEMY == null:
					SERVANT_MAGICIAN_ENEMY = load("res://Scenes/Enemys/All_enemys/Servant_magic_enemy/servant_magic_enemy.tscn")

				buff = SERVANT_MAGICIAN_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) / 4
				buff.player_damage = WaveGeneration.how_many_damage_player(11) / 4
			12:
				if POISON_ENEMY == null:
					POISON_ENEMY = load("res://Scenes/Enemys/All_enemys/Poison_enemy/poison_enemy.tscn")

				buff = POISON_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(12)
			13:
				if BERSERKER_ENEMY == null:
					BERSERKER_ENEMY = load("res://Scenes/Enemys/All_enemys/Berserker_enemy/berserker_enemy.tscn")

				buff = BERSERKER_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave)
				buff.player_damage = WaveGeneration.how_many_damage_player(13)
			14:
				if FIRE_ELEMENTAL_ENEMY == null:
					FIRE_ELEMENTAL_ENEMY = load("res://Scenes/Enemys/All_enemys/Fire_elemental_enemy/fire_elemental_enemy.tscn")

				buff = FIRE_ELEMENTAL_ENEMY.instantiate()
				buff.hp_enemy = WaveGeneration.how_many_hp_plus_enemy(count_wave) * 0.8
				buff.player_damage = WaveGeneration.how_many_damage_player(14)
			15:
				buff = load("res://Scenes/Enemys/Bosses/Shield_boss/shield_boss.tscn").instantiate()
				buff.died.connect(_on_boss_died)
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6)] = buff
				LevelManager.first_level_links_on_objects[(count/6)][(count%6) + 1] = buff
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6) + 1] = buff
				buff.hp_enemy = (WaveGeneration.how_many_hp_plus_enemy(count_wave - 1)) * 9
				buff.player_damage = WaveGeneration.how_many_damage_player(1) * 2
				LevelManager.boss_on_map = true
				$UI/Boss_label.visible = true
				count_level_label.visible = false
				notification_about_boss_here()
			16:
				buff = load("res://Scenes/Enemys/Bosses/Berserker_boss/berserker_boss.tscn").instantiate()
				buff.died.connect(_on_boss_died)
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6)] = buff
				LevelManager.first_level_links_on_objects[(count/6)][(count%6) + 1] = buff
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6) + 1] = buff
				buff.hp_enemy = (WaveGeneration.how_many_hp_plus_enemy(count_wave - 1)) * 9
				buff.player_damage = WaveGeneration.how_many_damage_player(1) * 2
				LevelManager.boss_on_map = true
				$UI/Boss_label.visible = true
				count_level_label.visible = false
				notification_about_boss_here()
			17:
				buff = load("res://Scenes/Enemys/Bosses/Fire_elemental_boss/Fire_elemental_boss.tscn").instantiate()
				buff.died.connect(_on_boss_died)
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6)] = buff
				LevelManager.first_level_links_on_objects[(count/6)][(count%6) + 1] = buff
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6) + 1] = buff
				buff.hp_enemy = (WaveGeneration.how_many_hp_plus_enemy(count_wave - 1) * 0.8) * 9
				buff.player_damage = WaveGeneration.how_many_damage_player(2) * 2
				LevelManager.boss_on_map = true
				$UI/Boss_label.visible = true
				count_level_label.visible = false
				notification_about_boss_here()
			18:
				buff = load("res://Scenes/Enemys/Bosses/Magician_boss/magician_boss.tscn").instantiate()
				buff.died.connect(_on_boss_died)
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6)] = buff
				LevelManager.first_level_links_on_objects[(count/6)][(count%6) + 1] = buff
				LevelManager.first_level_links_on_objects[(count/6) + 1][(count%6) + 1] = buff
				buff.hp_enemy = (WaveGeneration.how_many_hp_plus_enemy(count_wave - 1) * 0.6) * 9
				buff.player_damage = WaveGeneration.how_many_damage_player(1) * 2
				LevelManager.boss_on_map = true
				$UI/Boss_label.visible = true
				count_level_label.visible = false
				notification_about_boss_here()

		if LevelManager.boss_on_map:
			buff.hp_enemy *= WaveGeneration.get_coef_hp_enemy_when_boss_on_map()

		if _current_obj_id > 0:
			buff.died.connect(_on_enemy_died.bind(buff))
		buff.position = $Dicariations/Setka.global_position + Vector2((count%6) * 103, (count/6) * 103)
		LevelManager.first_level_links_on_objects[count/6][count%6] = buff
		game_objects.add_child(buff)

func show_ball_tutorial() -> void:
	await get_tree().create_timer(0.8).timeout
	$Tutorial/Label2.visible = true
	$Tutorial.visible = true

func show_skill_tutorial() -> void:
	await get_tree().create_timer(0.8).timeout
	$Tutorial/Label2.visible = false
	$Tutorial/Label3.visible = true
	$Tutorial.visible = true

func end_wave() -> void:
	if is_boss_dead:
		_set_state(State.WIN)
		return

	LevelManager.apeend_new_balls()
	balls_back_button.visible = false
	count_ball_label.text = "x" + str(LevelManager.player_balls.size())
	LevelManager.combo_count = 0
	count_get_experience_on_wave = 0
	get_count_experience_label.text = ""

	animation_health()
	animation_bank_with_experience()

	if !LevelManager.boss_on_map:
		get_health(PlayerIndicatorsManager.FOR_COIS_REGENIRATION)

	LevelManager.moving_object(start_balls_position.position)

	if LevelManager.hit_player:
		await get_tree().create_timer(4).timeout
	else:
		await get_tree().create_timer(2).timeout

	if LevelManager.hp_player <= 0:
		if "Оживление" in LevelManager.player_skills and revaving_from_skill == false:
			character_anim.death()
			await Utils.timeout(2)
			character_anim.alive()
			revaving_from_skill = true
			LevelManager.revival(1, true)
			update_character_label()
		else:
			hp_player_bar.value = 0
			hp_player_label.text = "0"
			character_anim.death()

			await Utils.timeout(2)
			end_game_UI_lose.start_timer()

			_set_state(State.LOSE)
			return
	else:
		update_character_label()

	LevelManager.updete_last_line()
	spawn_objects_on_matrix()

	if LevelManager.boss_on_map:
		$UI/Boss_label.visible = true
		count_level_label.visible = false
	else:
		count_level_label.visible = true
		count_level_label.text = str(LevelManager.count_level + 1)

	# Metrika
	var completed_level = LevelManager.count_level
	var current_location = 1 + WaveGeneration.get_current_location()
	if current_location == 1 and LevelManager.count_level < 21:
		var target_name = 'completed_loc_%d_level_%d' % [current_location, completed_level]
		YandexMetrika.ym(101336789,'reachGoal',target_name)

		if skill_tutorial_was_shown and skill_tutorial_was_shown_on_level + 1 == completed_level:
			YandexMetrika.ym(101336789,'reachGoal','complete_level_3_with_skill_tutorial')
			skill_tutorial_was_shown = false
			skill_tutorial_was_shown_on_level = -1

	LevelManager.delete_freezing_and_fire_on_enemy()
	if is_boss_dead:
		_set_state(State.WIN)
		return

	if count_level_label.text == str(WaveGeneration.get_count_wave_on_location() - 1) and count_level_label.visible and notification_about_boss_close == false:
		notification_about_boss_animation.play("boss_close")
		notification_about_boss_close = true
		await notification_about_boss_animation.animation_finished
	elif notification_about_boss_animation.current_animation == "spawn_boss":
		await notification_about_boss_animation.animation_finished

	LevelManager.kill_on_whis_wave = 0
	if LevelManager.spin_skill > 0:
		choose_skill_UI.visible = true
		choose_skill_UI.get_number_skill(LevelManager.spin_skill)

		_set_state(State.CHOOSE_SKILL)
		return

	await Utils.timeout(0.5)

	_set_state(State.PLAY)


func notification_about_new_enemy(num_enemy) -> void:
	if is_boss_dead:
		return

	while LevelManager.spin_skill > 0:
		await get_tree().create_timer(0.1).timeout
	var play_anim = false

	var enemies_info = {
		1: {
			"name": tr("ENEMY_ROGUE_NAME"),
			"description": tr("ENEMY_ROGUE_DESCR"),
		},
		2: {
			"name": tr("ENEMY_BLUEBERRY_NAME"),
			"description": tr("ENEMY_BLUEBERRY_DESCR")
		},
		3: {
			"name": tr("ENEMY_BOMB_NAME"),
			"description": tr("ENEMY_BOMB_DESCR")
		},
		#4: {
			#"name": tr("ENEMY__NAME"),
			#"description": tr("ENEMY__DESCR")
		#},
		5: {
			"name": tr("ENEMY_HEALER_NAME"),
			"description": tr("ENEMY_HEALER_DESCR")
		},
		6: {
			"name": tr("ENEMY_SLIME_NAME"),
			"description": tr("ENEMY_SLIME_DESCR")
		},
		8: {
			"name": tr("ENEMY_SHIELDBEARER_NAME"),
			"description": tr("ENEMY_SHIELDBEARER_NAME")
		},
		9: {
			"name": tr("ENEMY_JUMPER_NAME"),
			"description": tr("ENEMY_JUMPER_DESCR")
		},
		10: {
			"name": tr("ENEMY_SUMMONER_NAME"),
			"description": tr("ENEMY_SUMMONER_DESCR")
		},
		12: {
			"name": tr("ENEMY_POISON_BUG_NAME"),
			"description": tr("ENEMY_POISON_BUG_DESCR")
		},
		13: {
			"name": tr("ENEMY_BERSERKER_NAME"),
			"description": tr("ENEMY_BERSERKER_DESCR")
		},
		14: {
			"name": tr("ENEMY_FIRE_ELEMENTAL_NAME"),
			"description": tr("ENEMY_FIRE_ELEMENTAL_DESCR")
		},
	}
	match num_enemy:
		1:
			if PlayerIndicatorsManager.ENEMY_1_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/1".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		2:
			if PlayerIndicatorsManager.ENEMY_2_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/2".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		3:
			if PlayerIndicatorsManager.ENEMY_3_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/3".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		5:
			if PlayerIndicatorsManager.ENEMY_5_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/5".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		6:
			if PlayerIndicatorsManager.ENEMY_6_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/6".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		8:
			if PlayerIndicatorsManager.ENEMY_8_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/8".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		9:
			if PlayerIndicatorsManager.ENEMY_9_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/9".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		10:
			if PlayerIndicatorsManager.ENEMY_10_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/10".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		12:
			if PlayerIndicatorsManager.ENEMY_12_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/12".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		13:
			if PlayerIndicatorsManager.ENEMY_13_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/13".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
		14:
			if PlayerIndicatorsManager.ENEMY_14_FIRST_TIME == 0:
				$"UI/Notification_about_enemy/For_PC/14".visible = true
				$UI/Notification_about_enemy/For_PC/Enemy_name.text = enemies_info[num_enemy].name
				$UI/Notification_about_enemy/For_PC/Enemy_discription.text = enemies_info[num_enemy].description
				play_anim = true
	if play_anim:
		await get_tree().create_timer(1).timeout
		$UI/Notification_about_enemy/AnimationPlayer.play("for_pc")
		PlayerIndicatorsManager.enemy_firs_time_spawn(num_enemy)


func notification_about_boss_here() -> void:
	var boss_info = {
		"BLUEBERRY": {
			"name": tr("BOSS_NAME_BLUEBERRY"),
			"description": tr("BOSS_DESC_BLUEBERRY")
		},
		"SHIELDBEARER": {
			"name": tr("BOSS_NAME_SHIELDBEARER"),
			"description": tr("BOSS_DESC_SHIELDBEARER")
		},
		"NECROMANCER": {
			"name": tr("BOSS_NAME_NECROMANCER"),
			"description": tr("BOSS_DESC_NECROMANCER")
		},
		"LAVA_GOLEM": {
			"name": tr("BOSS_NAME_LAVA_GOLEM"),
			"description": tr("BOSS_DESC_LAVA_GOLEM")
		},
		"ODIN_WARRIOR": {
			"name": tr("BOSS_NAME_ODIN_WARRIOR"),
			"description": tr("BOSS_DESC_ODIN_WARRIOR")
		},
	}

	$"UI/Reminder_boss/Boss_here/1".visible = false
	$"UI/Reminder_boss/Boss_here/2".visible = false
	$"UI/Reminder_boss/Boss_here/3".visible = false
	$"UI/Reminder_boss/Boss_here/4".visible = false
	$"UI/Reminder_boss/Boss_here/5".visible = false

	# TODO: сократить однотипный код
	if ((WaveGeneration.current_location % 10) - 1) == 0 or ((WaveGeneration.current_location % 10) - 1) == 1:
		$UI/Reminder_boss/Boss_here.text = boss_info.BLUEBERRY.name
		$UI/Reminder_boss/Boss_here/Label2.text = boss_info.BLUEBERRY.description
		$"UI/Reminder_boss/Boss_here/1".visible = true
		notification_about_boss_animation.play("spawn_boss")
	elif ((WaveGeneration.current_location % 10) - 1) == 2 or ((WaveGeneration.current_location % 10) - 1) == 3:
		$UI/Reminder_boss/Boss_here.text = boss_info.SHIELDBEARER.name
		$UI/Reminder_boss/Boss_here/Label2.text = boss_info.SHIELDBEARER.description
		$"UI/Reminder_boss/Boss_here/2".visible = true
		notification_about_boss_animation.play("spawn_boss")
	elif ((WaveGeneration.current_location % 10) - 1) == 4 or ((WaveGeneration.current_location % 10) - 1) == 5:
		$UI/Reminder_boss/Boss_here.text = boss_info.NECROMANCER.name
		$UI/Reminder_boss/Boss_here/Label2.text = boss_info.NECROMANCER.description
		$"UI/Reminder_boss/Boss_here/3".visible = true
		notification_about_boss_animation.play("spawn_boss")
	elif ((WaveGeneration.current_location % 10) - 1) == 6 or ((WaveGeneration.current_location % 10) - 1) == 7:
		$UI/Reminder_boss/Boss_here.text = boss_info.LAVA_GOLEM.name
		$UI/Reminder_boss/Boss_here/Label2.text = boss_info.LAVA_GOLEM.description
		$"UI/Reminder_boss/Boss_here/4".visible = true
		notification_about_boss_animation.play("spawn_boss")
	elif ((WaveGeneration.current_location % 10) - 1) == 8 or ((WaveGeneration.current_location % 10) - 1) == -1:
		$UI/Reminder_boss/Boss_here.text = boss_info.ODIN_WARRIOR.name
		$UI/Reminder_boss/Boss_here/Label2.text = boss_info.ODIN_WARRIOR.description
		$"UI/Reminder_boss/Boss_here/5".visible = true
		notification_about_boss_animation.play("spawn_boss")


func animation_bank_with_experience() -> void:
	kill_on_wave = LevelManager.kill_on_whis_wave
	var count_exp = 25 * ((kill_on_wave * (kill_on_wave + 1)) / 2)
	LevelManager.count_experiance += round(count_exp)

	while experience_object_list.size():
		var _exp = experience_object_list.pop_back()
		_exp.go_to_count()
		await Utils.timeout(0.1)


func animation_health() -> void:
	while heal_object_list.size():
		var _hp = heal_object_list.pop_back()
		_hp.go_to_player(start_balls_position.position)
		await get_tree().create_timer(0.1).timeout


func _on_balls_back_pressed() -> void:
	balls_back_button.visible = false
	for child in self.get_children():
		if child.has_method("ball"):
			child.return_to_player(start_balls_position.position)

func _on_button_pause_pressed() -> void:
	AudioManager.click()
	pause_menu_UI.update_texture_skill()
	YandexSDK.gameplay_stopped()
	pause_menu_UI.visible = true
	get_tree().paused = true
	Engine.time_scale = 0

func update_character_label() -> void:
	hp_player_bar.value = LevelManager.hp_player
	hp_player_label.text = str(int(LevelManager.hp_player))
	if LevelManager.hp_player>=10000:
		if int(LevelManager.hp_player) % 10000 == 0:
			hp_player_label.text = str(int(LevelManager.hp_player / 1000)) + "K"
		elif int(LevelManager.hp_player) % 10000 != 0:
			hp_player_label.text = ("%.1f" % (LevelManager.hp_player / 1000)) + "K"
	else:
		hp_player_label.text = str(roundi(LevelManager.hp_player))


# ЭТО ДЛЯ ТЕСТИРОВАНИЯ, ПОТОМ УДАЛИТЬ
func _chose_ball_button_pressed():
	$UI/Chose_ball.visible = true


func _on_get_skill_ui_skill_taken(skill: Variant) -> void:
	count_experience_label.text = str(LevelManager.count_experiance)
	hp_player_bar.max_value = LevelManager.max_hp_player
	update_character_label()
	LevelManager.apeend_new_balls()
	count_ball_label.text = "x" + str(LevelManager.player_balls.size())
	count_experience_label.text = str(LevelManager.count_experiance)

	# Задержка что-бы при клике на скил не запускались шарики на игровом поле
	await Utils.timeout(0.3)
	_set_state(State.PLAY)


func _on_get_skill_ui_update_skill() -> void:
	count_experience_label.text = str(LevelManager.count_experiance)


func _on_boss_died() -> void:
	is_boss_dead = true


func _on_enemy_died(enemy) -> void:
	if not enemy.is_boss():
		# эффект смерти
		var death_effect = ObjectPool.get_object("enemy_death_effect")
		death_effect.global_position = enemy.global_position
		death_effect.start_animation()

		# Создаём бутылочку опыта на месте павшего противника
		var _exp_potion = ObjectPool.get_object("experience_potion")
		_exp_potion.position = enemy.global_position + Vector2(randi() % 5 - 25, randi() % 5 - 25)
		experience_object_list.push_back(_exp_potion)

		# Проверяем шанс выпадения зелья лечения
		if randf() <= PlayerIndicatorsManager.get_heal_drop_chance():
			var _health = ObjectPool.get_object("heal_potion")
			_health.position = enemy.global_position + Vector2(randi() % 5 + 25, randi() % 5 + 25)
			heal_object_list.push_back(_health)


func _on_get_skill_ui_update_exp() -> void:
	count_experience_label.text = str(LevelManager.count_experiance)
