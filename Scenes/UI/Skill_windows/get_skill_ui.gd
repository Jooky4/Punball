extends Control

var SKILL_WINDOW = preload("res://Scenes/UI/Skill_windows/skill_window.tscn")
var BUTTON_NOT_CAN_PRESS_TEXTURE = preload("res://Texture/UI/Skills_UI/кнопка покупки неактивная.png")
var BUTTON_CAN_PRESS_TEXTURE = preload("res://Texture/UI/Skills_UI/кнопка покупки активная (кнопка рекламы).png")

@onready var windows_skill = $Windows_skill
@onready var animation = $AnimationPlayer
@onready var bye_button = $Bye_button
@onready var sound_scroll = $Get_skill_scrolling
var skil_for_ad = 0
var regular = [["Шар-заморозка", 200],
			   ["Лед: комбо", 180],
			   ["Ядерная: комбо", 110],
			   ["Прибавка к восстановлению", 0],
			   ["Прибавка ОЗ", 0],
			   ["Усиление обычного шара", 0]]
var rare = [["Огненный шар", 400],
			["Шар-бомба", 450],
			["Бомба-заморозка", 480],
			["Молния: комбо", 210],
			["Лазер: комбо", 250],
			["Огонь: комбо", 250],
			["Шар ракета", 280],
			["Кумулятивный шар", 500],
			["Шар удара в спину", 460],
			["Шар убийца", 490],
			["Технология: комбо с тыла", 210],
			["Технология: комбо с фронта", 210],
			["Усиление особого шара", 280],
			["Усиление атаки", 490],
			["Комбо: скидка", 260],
			["Суперначало", 390]]
var epic = [["Шар молний",  600],
			["Повелитель льда", 1000],
			["Повелитель огня", 1080],
			["Рассыпающийся шар", 580],
			["Вертикальный лазерный шар", 680],
			["Горизонтальный лазерный шар", 700],
			["Повелитель лазера", 1140],
			["Шар ракета", 600],
			["Повелитель атома", 970],
			["Бурящий шар", 1000],
			["Ловушка", 1080],
			["Холод смерти", 1060],
			["Повелитель молний", 970]]
var legendary = [["Молния смерти", 1220],
				 ["Бомба смерти", 1220],
				 ["Лазер смерти", 1220],
				 ["Ракета смерти", 1220],
				 ["Повелитель технологий", 1380],
				 ["Оживление", 1820], 
				 ["Последний рывок", 1320]]
var skill_discription = {
	"Шар-заморозка" : "Пример описания",
	"Лед: комбо" : "Пример описания",
	"Ядерная: комбо" : "Пример описания",
	"Прибавка к восстановлению" : "Пример описания",
	"Прибавка ОЗ" : "Пример описания",
	"Усиление обычного шара" : "Пример описания",
	"Огненный шар" : "Пример описания",
	"Шар-бомба" : "Пример описания",
	"Бомба-заморозка" : "Пример описания",
	"Молния: комбо" : "Пример описания",
	"Лазер: комбо" : "Пример описания",
	"Огонь: комбо" : "Пример описания",
	"Кумулятивный шар" : "Пример описания",
	"Шар удара в спину" : "Пример описания",
	"Шар убийца" : "Пример описания",
	"Технология: комбо с тыла" : "Пример описания",
	"Технология: комбо с фронта" : "Пример описания",
	"Усиление особого шара" : "Пример описания",
	"Усиление атаки" : "Пример описания",
	"Комбо: скидка" : "Пример описания",
	"Суперначало" : "Пример описания",
	"Шар молний" : "Пример описания",
	"Повелитель льда" : "Пример описания",
	"Повелитель огня" : "Пример описания",
	"Рассыпающийся шар" : "Пример описания",
	"Вертикальный лазерный шар" : "Пример описания",
	"Горизонтальный лазерный шар" : "Пример описания",
	"Повелитель лазера" : "Пример описания",
	"Шар ракета" : "Пример описания",
	"Повелитель атома" : "Пример описания",
	"Бурящий шар" : "Пример описания",
	"Ловушка" : "Пример описания",
	"Холод смерти" : "Пример описания",
	"Повелитель молний" : "Пример описания",
	"Молния смерти" : "Пример описания",
	"Бомба смерти" : "Пример описания",
	"Лазер смерти" : "Пример описания",
	"Ракета смерти" : "Пример описания",
	"Повелитель технологий" : "Пример описания",
	"Оживление" : "Пример описания",
	"Последний рывок" : "Пример описания"
}
var skills = []
var all_skills = []
var skills_once = ["Молния смерти",
				  "Повелитель молний",
				  "Молния: комбо",
				  "Холод смерти",
				  "Повелитель льда",
				  "Лед: комбо",
				  "Бомба смерти",
				  "Повелитель огня",
				  "Огонь: комбо",
				  "Лазер смерти",
				  "Повелитель лазера",
				  "Лазер: комбо",
				  "Ракета смерти",
				  "Повелитель атома",
				  "Ядерная: комбо",
				  "Ловушка",
				  "Повелитель технологий",
				  "Технология: комбо с фронта",
				  "Технология: комбо с тыла",
				  "Суперначало",
				  "Последний рывок",
				  "Оживление",
				  "Комбо: скидка"]

func _ready() -> void:
	self.visible = false
	all_skills.append_array(regular)
	all_skills.append_array(rare)
	all_skills.append_array(epic)
	all_skills.append_array(legendary)

func _on_continue_game_pressed() -> void:
	LevelManager.spin_skill -= 1
	if LevelManager.spin_skill <= 0:
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
	var button_arr = bye_button.get_children()
	skil_for_ad = 0
	sound_scroll.playing = true
	sound_scroll.pitch_scale = 1.1
	$Update_skill_button.visible = false
	for i in bye_button.get_children():
		i.disabled = true
		i.texture_normal = BUTTON_CAN_PRESS_TEXTURE
		for j in i.get_children():
				if "AD" in j.name:
					j.visible = false

	var spread = LevelManager.count_experiance * (1 - ((LevelManager.count_experiance - 400) / (23.67 * 100)))
	var min_cost = LevelManager.count_experiance - spread
	var max_cost = LevelManager.count_experiance
	var skill_with_max_cost
	var skill_can_drop = []
	var not_can_buy_skills = []

	var skill_max_cost = -1
	all_skills.shuffle()
	for i in all_skills:
		if i[0] not in LevelManager.player_skills:
			if min_cost <= i[1] and i[1] <= max_cost:
				skill_can_drop.append(i)
				if i[1] > skill_max_cost:
					skill_with_max_cost = i
					skill_max_cost = i[1]
			if i[1] > LevelManager.count_experiance:
				not_can_buy_skills.append(i)
	skill_can_drop.shuffle()
	not_can_buy_skills.shuffle()

	for i in range(3):
		var random_index = randi() % skill_can_drop.size()
		var new_skill = skill_can_drop[random_index]
		if i == 2:
			if (randi() % 100 + 1) <= 30:
				new_skill = skill_with_max_cost
		skills.append(new_skill)
		skill_can_drop.remove_at(random_index)
	skills.sort_custom(Callable(self, "compare_skills"))
	if (randi() % 100 + 1) <= 30:
		skills[2] = not_can_buy_skills[randi() % not_can_buy_skills.size()]

	for i in windows_skill.get_children():
		i.queue_free()
	for i in skills:
		var buff = SKILL_WINDOW.instantiate()
		windows_skill.add_child(buff)
		buff.update_discription(skill_discription[i[0]])
		if i in regular:
			rare_skills.append(1)
			buff.show_rarity_window(i[0], 1)
		elif i in rare:
			rare_skills.append(2)
			buff.show_rarity_window(i[0], 2)
		elif i in epic:
			rare_skills.append(3)
			buff.show_rarity_window(i[0], 3)
		elif i in legendary:
			rare_skills.append(4)
			buff.show_rarity_window(i[0], 4)

	for i in range(skills.size()):
		if skills[i][1] > LevelManager.count_experiance:
			button_arr[i].texture_normal = BUTTON_NOT_CAN_PRESS_TEXTURE
			button_arr[i].disabled = true

	var count : int = 0
	for i in button_arr:
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
	for i in range(skills.size()):
		if skills[i][1] > LevelManager.count_experiance:
			for j in button_arr[i].get_children():
				if "AD" in j.name:
					j.visible = true
		else:
			button_arr[i].disabled = false
	$Update_skill_button.visible = true

func compare_skills(a, b):
	return a[1] < b[1] 

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
	LevelManager.buy_skill(skills[0][1])
	add_skill(skills[0][0])

func _on_skill_2_pressed() -> void:
	AudioManager.click()
	LevelManager.buy_skill(skills[1][1])
	add_skill(skills[1][0])

func _on_skill_3_pressed() -> void:
	AudioManager.click()
	LevelManager.buy_skill(skills[2][1])
	add_skill(skills[2][0])

func add_skill(skill) -> void:
	match skill:
		"Рассыпающийся шар":
			LevelManager.add_ball(2)
			LevelManager.player_skills.append("Рассыпающийся шар")
		"Шар-бомба":
			LevelManager.add_ball(3)
			LevelManager.player_skills.append("Шар-бомба")
		"Шар-заморозка":
			LevelManager.add_ball(4)
			LevelManager.player_skills.append("Шар-заморозка")
		"Шар молний":
			LevelManager.add_ball(5)
			LevelManager.player_skills.append("Шар молний")
		"Бомба-заморозка":
			LevelManager.add_ball(6)
			LevelManager.player_skills.append("Бомба-заморозка")
		"Огненный шар":
			LevelManager.add_ball(7)
			LevelManager.player_skills.append("Огненный шар")
		"Горизонтальный лазерный шар":
			LevelManager.add_ball(8)
			LevelManager.player_skills.append("Горизонтальный лазерный шар")
		"Вертикальный лазерный шар":
			LevelManager.add_ball(9)
			LevelManager.player_skills.append("Вертикальный лазерный шар")
		"Шар ракета":
			LevelManager.add_ball(10)
			LevelManager.player_skills.append("Шар ракета")
		"Кумулятивный шар":
			LevelManager.add_ball(11)
			LevelManager.player_skills.append("Кумулятивный шар")
		"Шар убийца":
			LevelManager.add_ball(12)
			LevelManager.player_skills.append("Шар убийца")
		"Бурящий шар":
			LevelManager.add_ball(13)
			LevelManager.player_skills.append("Бурящий шар")
		"Шар удара в спину":
			LevelManager.add_ball(14)
			LevelManager.player_skills.append("Шар удара в спину")
		"Усиление обычного шара":
			ElementsManager.normal_modifier += 0.1
			LevelManager.player_skills.append("Усиление обычного шара")
		"Прибавка ОЗ":
			var prosen_hp_plus = 0.1
			if "Прибавка к восстановлению" in LevelManager.player_skills:
				prosen_hp_plus *= 1.5
			LevelManager.hp_player = round(LevelManager.hp_player + (LevelManager.max_hp_player * prosen_hp_plus))
			LevelManager.max_hp_player = round(LevelManager.max_hp_player * (1 + prosen_hp_plus))
			AudioManager.health_sound()
			LevelManager.player_skills.append("Прибавка ОЗ")
		"Усиление особого шара":
			LevelManager.player_skills.append("Усиление особого шара")
		"Усиление атаки":
			ElementsManager.normal_modifier += 0.1
			ElementsManager.fire_modifier += 0.1
			ElementsManager.frost_modifier += 0.1
			ElementsManager.laser_modifier += 0.1
			ElementsManager.lightning_modifier += 0.1
			ElementsManager.nuclear_modifier += 0.1
			ElementsManager.technologies_modifier += 0.1
			LevelManager.player_skills.append("Усиление атаки")
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
			LevelManager.player_skills.append("Повелитель молний")
		"Повелитель льда":
			ElementsManager.frost_modifier += 0.4
			LevelManager.chance_of_freezing += 0.3
			LevelManager.player_skills.append("Повелитель льда")
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
	if 100 <= LevelManager.count_experiance:
		LevelManager.buy_skill(100)
		AudioManager.click()
		for i in windows_skill.get_children():
			i.queue_free()
		skills.clear()
		create_skill()

func _on_skill_for_ad_pressed(extra_arg_0: int) -> void:
	AudioManager.click()
	AudioServer.set_bus_mute(0, true)
	skil_for_ad = extra_arg_0
	YandexSDK.show_rewarded_ad()
	YandexSDK.connect("rewarded_ad", rew_ad_res)

func rew_ad_res(result:String) -> void:
	if result == "closed" or result == "error":
		AudioServer.set_bus_mute(0, false)
	elif result == "rewarded":
		AudioServer.set_bus_mute(0, false)
		add_skill(skills[skil_for_ad][0])
