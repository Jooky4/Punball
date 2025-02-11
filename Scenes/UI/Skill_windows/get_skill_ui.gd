extends Control

var SKILL_WINDOW = preload("res://Scenes/UI/Skill_windows/skill_window.tscn")

@onready var windows_skill = $Windows_skill
@onready var animation = $AnimationPlayer
var regular = ["Шар-заморозка", "Усиление обычного шара", "Шар молний", "Огненный шар"]
var rare = ["Рассыпающийся шар", "Шар-бомба", "Усиление особого шара", "Прибавка ОЗ", "Молния смерти", "Бомба-заморозка", "Холод смерти", "Бомба смерти"]
var epic = ["Усиление атаки", "Повелитель молний", "Повелитель льда"]
var legendary = []
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
	for i in range(3):
		var buff = SKILL_WINDOW.instantiate()
		if i == 0:
			var new_skill = regular[randi() % regular.size()]
			buff.update_discription(new_skill)
			skills.append(new_skill)
			buff.show_rarity_window(1)
		elif i == 1:
			var new_skill = rare[randi() % rare.size()]
			buff.update_discription(new_skill)
			skills.append(new_skill)
			buff.show_rarity_window(2)
		elif i == 2:
			var new_skill = epic[randi() % epic.size()]
			buff.update_discription(new_skill)
			skills.append(new_skill)
			buff.show_rarity_window(3)
		windows_skill.add_child(buff)

func _on_skill_1_pressed() -> void:
	add_skill(skills[0])

func _on_skill_2_pressed() -> void:
	add_skill(skills[1])

func _on_skill_3_pressed() -> void:
	add_skill(skills[2])

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
