extends Control

var SKILL_WINDOW = preload("res://Scenes/UI/Skill_windows/skill_window.tscn")

@onready var windows_skill = $Windows_skill
@onready var animation = $AnimationPlayer
var regular = ["Шар-заморозка", "Усиление обычного шара"]
var rare = ["Рассыпающийся шар", "Шар-бомба", "Усиление особого шара", "Прибавка ОЗ"]
var epic = []
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
		if randi() % 2 == 1:
			var new_skill = rare[randi() % rare.size()]
			buff.update_discription(new_skill)
			buff.show_rarity_window(3)
			skills.append(new_skill)
		else:
			var new_skill = regular[randi() % regular.size()]
			buff.update_discription(new_skill)
			buff.show_rarity_window(1)
			skills.append(new_skill)
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
	_on_continue_game_pressed()
