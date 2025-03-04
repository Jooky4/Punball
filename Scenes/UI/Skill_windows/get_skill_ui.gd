extends Control

var SKILL_WINDOW = preload("res://Scenes/UI/Skill_windows/skill_window.tscn")

@onready var windows_skill = $Windows_skill
@onready var animation = $AnimationPlayer
@onready var bye_button = $Bye_button
@onready var sound_scroll = $Get_skill_scrolling
var regular = [["Шар-заморозка", 150],
			   ["Усиление обычного шара", 0],
			   ["Огненный шар", 120],
			   ["Усиление особого шара", 100],
			   ["Последний рывок", 30],
			   ["Суперначало", 30]]
var rare = [["Шар молний",  350],
			["Рассыпающийся шар", 280],
			["Шар-бомба", 300],
			["Прибавка ОЗ", 200],
			["Бомба-заморозка", 250],
			["Молния: комбо", 380],
			["Лед: комбо", 250],
			["Огонь: комбо", 250],
			["Вертикальный лазерный шар", 220],
			["Горизонтальный лазерный шар", 220],
			["Шар ракета", 280],
			["Кумулятивный шар", 320],
			["Ядерная: комбо", 300],
			["Шар удара в спину", 150],
			["Шар убийца", 200],
			["Бурящий шар", 300],
			["Технология: комбо с тыла", 350],
			["Технология: комбо с фронта", 350],
			["Прибавка к восстановлению", 250]]
var epic = [["Усиление атаки", 550],
			["Молния смерти", 500],
			["Холод смерти", 450],
			["Бомба смерти", 600],
			["Лазер смерти", 430],
			["Лазер: комбо", 650],
			["Ракета смерти", 700],
			["Ловушка", 1000],
			["Комбо: скидка", 450]]
var legendary = [["Повелитель молний", 1200],
				 ["Повелитель льда", 1350],
				 ["Повелитель огня", 1000],
				 ["Повелитель лазера", 780],
				 ["Повелитель атома", 1300],
				 ["Повелитель технологий", 1100],
				 ["Оживление", 1200]]
var skills = []

func _ready() -> void:
	visible = false

func _on_continue_game_pressed() -> void:
	LevelManager.spin_skill -= 1
	if LevelManager.spin_skill == 0:
		animation.play("windows_output")
	else:
		get_number_skill(LevelManager.spin_skill)

func get_number_skill(number:int) -> void:
	for i in windows_skill.get_children():
		i.queue_free()
	skills.clear()
	animation.play("window_input")
	create_skill()

func create_skill():
	var rare_skills = []
	sound_scroll.playing = true
	sound_scroll.pitch_scale = 1.1
	for i in bye_button.get_children():
		i.disabled = true
	$Update_skill_button.visible = false
	for i in range(3):
		var buff = SKILL_WINDOW.instantiate()
		windows_skill.add_child(buff)
		if i == 0:
			var new_skill = regular[randi() % regular.size()]
			buff.update_discription(new_skill[0])
			skills.append(new_skill)
			rare_skills.append(1)
			buff.show_rarity_window(1)
		elif i == 1:
			var new_skill = rare[randi() % epic.size()]
			buff.update_discription(new_skill[0])
			skills.append(new_skill)
			rare_skills.append(2)
			buff.show_rarity_window(2)
		elif i == 2:
			var new_skill = epic[randi() % epic.size()]
			buff.update_discription(new_skill[0])
			skills.append(new_skill)
			rare_skills.append(3)
			buff.show_rarity_window(3)

	var count : int = 0
	for i in bye_button.get_children():
		for j in i.get_children():
			if j.name == "Label":
				j.text = str(skills[count][1])
		count += 1

	var time_wait = 0 
	if 4 in rare_skills:
		time_wait = 4
	elif 3 in rare_skills:
		time_wait = 2.6
	elif 2 in rare_skills:
		time_wait = 1.7
	elif 1 in rare_skills:
		time_wait = 1.2

	if 4 in rare_skills:
		legendary_sound()
	if 3 in rare_skills:
		epic_sound()
	if 2 in rare_skills:
		rare_sound()
	if 1 in rare_skills:
		regular_sound()

	create_tween().tween_property(sound_scroll, "pitch_scale", 0.9, time_wait - 0.25)
	await get_tree().create_timer(time_wait - 0.25).timeout
	sound_scroll.playing = false
	await get_tree().create_timer(0.25).timeout
	for i in bye_button.get_children():
		i.disabled = false
	$Update_skill_button.visible = true

func legendary_sound() -> void:
	await get_tree().create_timer(4).timeout
	$Legendari_skill.play()

func epic_sound() -> void:
	await get_tree().create_timer(2.6).timeout
	$Epic_skill.play()

func rare_sound() -> void:
	await get_tree().create_timer(1.7).timeout
	$Rare_skill.play()

func regular_sound() -> void:
	await get_tree().create_timer(1.1).timeout
	$Regular_skill.play()

func _on_skill_1_pressed() -> void:
	AudioManager.click()
	add_skill(skills[0][0])
	LevelManager.buy_skill(skills[0][1])

func _on_skill_2_pressed() -> void:
	AudioManager.click()
	add_skill(skills[1][0])
	LevelManager.buy_skill(skills[1][1])

func _on_skill_3_pressed() -> void:
	AudioManager.click()
	add_skill(skills[2][0])
	LevelManager.buy_skill(skills[2][1])

func add_skill(skill) -> void:
	match skill:
		"Рассыпающийся шар":
			LevelManager.add_ball(2)
		"Шар-бомба":
			LevelManager.add_ball(3)
		"Шар-заморозка":
			LevelManager.add_ball(4)
		"Шар молний":
			LevelManager.add_ball(5)
		"Бомба-заморозка":
			LevelManager.add_ball(6)
		"Огненный шар":
			LevelManager.add_ball(7)
		"Горизонтальный лазерный шар":
			LevelManager.add_ball(8)
		"Вертикальный лазерный шар":
			LevelManager.add_ball(9)
		"Шар ракета":
			LevelManager.add_ball(10)
		"Кумулятивный шар":
			LevelManager.add_ball(11)
		"Шар убийца":
			LevelManager.add_ball(12)
		"Бурящий шар":
			LevelManager.add_ball(13)
		"Шар удара в спину":
			LevelManager.add_ball(14)
		"Усиление обычного шара":
			ElementsManager.normal_modifier += 0.1
		"Прибавка ОЗ":
			var prosen_hp_plus = 0.1
			if "Прибавка к восстановлению" in LevelManager.player_skills:
				prosen_hp_plus *= 1.5
			LevelManager.hp_player = LevelManager.hp_player + (LevelManager.max_hp_player * prosen_hp_plus)
			LevelManager.max_hp_player = LevelManager.max_hp_player * (1 + prosen_hp_plus)
			AudioManager.health_sound()
		"Усиление особого шара":
			ElementsManager.fire_modifier += 0.1
			ElementsManager.frost_modifier += 0.1
			ElementsManager.laser_modifier += 0.1
			ElementsManager.lightning_modifier += 0.1
			ElementsManager.nuclear_modifier += 0.1
			ElementsManager.technologies_modifier += 0.1
		"Усиление атаки":
			ElementsManager.normal_modifier += 0.1
			ElementsManager.fire_modifier += 0.1
			ElementsManager.frost_modifier += 0.1
			ElementsManager.laser_modifier += 0.1
			ElementsManager.lightning_modifier += 0.1
			ElementsManager.nuclear_modifier += 0.1
			ElementsManager.technologies_modifier += 0.1
		"Оживление":
			LevelManager.player_skills.append("Оживление")
		"Прибавка к восстановлению":
			LevelManager.player_skills.append("Прибавка к восстановлению")
		"Суперначало":
			LevelManager.player_skills.append("Суперначало")
		"Последний рывок":
			LevelManager.player_skills.append("Последний рывок")
		"Ловушка":
			LevelManager.player_skills.append("Ловушка")
		"Молния смерти":
			LevelManager.player_skills.append("Молния смерти")
		"Холод смерти":
			LevelManager.player_skills.append("Холод смерти")
		"Бомба смерти":
			LevelManager.player_skills.append("Бомба смерти")
		"Лазер смерти":
			LevelManager.player_skills.append("Лазер смерти")
		"Ракета смерти":
			LevelManager.player_skills.append("Ракета смерти")
		"Лазер: комбо":
			LevelManager.player_skills.append("Лазер: комбо")
		"Молния: комбо":
			LevelManager.player_skills.append("Молния: комбо")
		"Лед: комбо":
			LevelManager.player_skills.append("Лед: комбо")
		"Огонь: комбо":
			LevelManager.player_skills.append("Огонь: комбо")
		"Ядерная: комбо":
			LevelManager.player_skills.append("Ядерная: комбо")
		"Технология: комбо с тыла":
			LevelManager.player_skills.append("Технология: комбо с тыла")
		"Технология: комбо с фронта":
			LevelManager.player_skills.append("Технология: комбо с фронта")
		"Комбо: скидка":
			LevelManager.player_skills.append("Комбо: скидка")
		"Повелитель молний":
			LevelManager.count_damage_lightning_enemy = 5
			ElementsManager.lightning_modifier += 0.4
		"Повелитель льда":
			ElementsManager.frost_modifier += 0.4
			LevelManager.chance_of_freezing += 0.3
		"Повелитель огня":
			ElementsManager.fire_modifier += 0.4
			LevelManager.player_skills.append("Повелитель огня")
		"Повелитель лазера":
			ElementsManager.laser_modifier += 0.4
			LevelManager.player_skills.append("Повелитель лазера")
		"Повелитель атома":
			ElementsManager.nuclear_modifier += 0.4
			LevelManager.player_skills.append("Повелитель атома")
		"Повелитель технологий":
			ElementsManager.technologies_modifier += 0.4
			LevelManager.player_skills.append("Повелитель технологий")
	_on_continue_game_pressed()

func _on_update_skill_button_pressed() -> void:
	AudioManager.click()
	for i in windows_skill.get_children():
		i.queue_free()
	skills.clear()
	create_skill()
	LevelManager.buy_skill(100)
