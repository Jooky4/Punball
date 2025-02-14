extends Control

var SKILL_WINDOW = preload("res://Scenes/UI/Skill_windows/skill_window.tscn")

@onready var windows_skill = $Windows_skill
@onready var animation = $AnimationPlayer
@onready var bye_button = $Bye_button
var regular = [["Шар-заморозка",  150],
			   ["Усиление обычного шара",  0],
			   ["Огненный шар", 120],
			   ["Усиление особого шара", 100]]
var rare = [["Шар молний",  350],
			["Рассыпающийся шар", 280],
			["Шар-бомба",  300],
			["Прибавка ОЗ", 200],
			["Бомба-заморозка", 250]]
var epic = [["Усиление атаки",  550],
			["Молния смерти", 500],
			["Холод смерти", 450],
			["Бомба смерти", 600]]
var legendary = [["Повелитель молний", 1200],
				 ["Повелитель льда",  1350],
				 ["Повелитель огня", 1000]]
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
	for i in bye_button.get_children():
		i.disabled = true
	$Update_skill_button.visible = false
	for i in range(3):
		var buff = SKILL_WINDOW.instantiate()
		if i == 0:
			var new_skill = regular[randi() % regular.size()]
			buff.update_discription(new_skill[0])
			skills.append(new_skill)
			buff.show_rarity_window(1)
		elif i == 1:
			var new_skill = rare[randi() % rare.size()]
			buff.update_discription(new_skill[0])
			skills.append(new_skill)
			buff.show_rarity_window(2)
		elif i == 2:
			var new_skill = epic[randi() % epic.size()]
			buff.update_discription(new_skill[0])
			skills.append(new_skill)
			buff.show_rarity_window(3)
		windows_skill.add_child(buff)

	var count : int = 0
	for i in bye_button.get_children():
		for j in i.get_children():
			if j.name == "Label":
				j.text = str(skills[count][1])
		count += 1
	await get_tree().create_timer(2.6).timeout
	for i in bye_button.get_children():
		i.disabled = false
	$Update_skill_button.visible = true

func _on_skill_1_pressed() -> void:
	add_skill(skills[0][0])
	LevelManager.buy_skill(skills[0][1])

func _on_skill_2_pressed() -> void:
	add_skill(skills[1][0])
	LevelManager.buy_skill(skills[1][1])

func _on_skill_3_pressed() -> void:
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
		"Усиление обычного шара":
			ElementsManager.normal_modifier += 0.1
		"Прибавка ОЗ":
			LevelManager.hp_player = LevelManager.hp_player + (LevelManager.max_hp_player * 0.1)
			LevelManager.max_hp_player = LevelManager.max_hp_player * 1.1
		"Усиление особого шара":
			ElementsManager.fire_modifier += 0.1
			ElementsManager.frost_modifier += 0.1
			ElementsManager.laser_modifier += 0.1
			ElementsManager.lightning_modifier += 0.1
			ElementsManager.darkness_modifier += 0.1
		"Усиление атаки":
			ElementsManager.normal_modifier += 0.1
			ElementsManager.fire_modifier += 0.1
			ElementsManager.frost_modifier += 0.1
			ElementsManager.laser_modifier += 0.1
			ElementsManager.lightning_modifier += 0.1
			ElementsManager.darkness_modifier += 0.1
		"Молния смерти":
			LevelManager.player_skills.append("Молния смерти")
		"Холод смерти":
			LevelManager.player_skills.append("Холод смерти")
		"Бомба смерти":
			LevelManager.player_skills.append("Бомба смерти")
		"Повелитель молний":
			LevelManager.count_damage_lightning_enemy = 5
			ElementsManager.lightning_modifier += 0.4
		"Повелитель льда":
			ElementsManager.frost_modifier += 0.4
			LevelManager.chance_of_freezing += 0.3
		"Повелитель огня":
			ElementsManager.fire_modifier += 0.4
			LevelManager.player_skills.append("Повелитель огня")
	_on_continue_game_pressed()

func _on_update_skill_button_pressed() -> void:
	for i in windows_skill.get_children():
		i.queue_free()
	skills.clear()
	create_skill()
	LevelManager.buy_skill(100)
