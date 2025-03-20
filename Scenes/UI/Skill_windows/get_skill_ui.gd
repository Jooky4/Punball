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
	"Шар-заморозка" : "Удар с шансом  заморозить врага до следующей волны",
	"Лед: комбо" : "Выпускает ледяной конус каждые 40 комбо",
	"Ядерная: комбо" : "Выпускает ракету каждые 40 комбо",
	"Прибавка к восстановлению" : "ОЗ восстанавливается в большем объеме",
	"Прибавка ОЗ" : "Максимальный ОЗ повышен",
	"Усиление обычного шара" : "Урон, наносимый обычными шарами, повышен",
	"Огненный шар" : "Наносит урон и поджигает врагов",
	"Шар-бомба" : "Взрывается, нанося урон по области",
	"Бомба-заморозка" : "Взрывается, нанося урон по области. Может сработать заморозка",
	"Молния: комбо" : "Пускает молнию каждые 40 комбо",
	"Лазер: комбо" : "Выпускает лазерный шар каждые 40 комбо",
	"Огонь: комбо" : "Выпускает огненный шар каждые 40 комбо",
	"Кумулятивный шар" : "Наносит врагу мощный урон один раз",
	"Шар удара в спину" : "Наносит врагам больше урона при атаке со спины",
	"Шар убийца" : "С небольшим шансом мгновенно убивает врага",
	"Технология: комбо с тыла" : "Наносит урон самому дальнему врагу каждые 40 комбо",
	"Технология: комбо с фронта" : "Наносит урон ближайшему врагу каждые 40 комбо",
	"Усиление особого шара" : "Урон, наносимый особыми шарами, повышен",
	"Усиление атаки" : "Урон от всех атак повышен",
	"Комбо: скидка" : "Для комбо навыков требуется на 10% меньше комбо",
	"Суперначало" : "Урон от первого шара Х300%",
	"Шар молний" : "Наносит 3м случайным врагам урон молнией",
	"Повелитель льда" : "Урон от льда повышен. Выше шанс заморозки",
	"Повелитель огня" : "Урон от огня повышен. Горение наносит урон по области",
	"Рассыпающийся шар" : "Рассыпается на несколько маленьких шариков",
	"Вертикальный лазерный шар" : "Наносит врагам урон вертикальным лазерным лучом",
	"Горизонтальный лазерный шар" : "Наносит врагам урон горизонтальным лазерным лучом",
	"Повелитель лазера" : "Урон от лазера повышается. Лазеры стреляют в 4х направлениях",
	"Шар ракета" : "Выпускает снаряд в самого слабого врага",
	"Повелитель атома" : "Урон от ракет повышен. +1 ракета при запуске ракет",
	"Бурящий шар" : "Пронзает всех врагов, рикошетя только от стен",
	"Ловушка" : "В момент смерти враги создают ловушки",
	"Холод смерти" : "Наносит урон по области вокруг убитого врага. Может сработать заморозка",
	"Повелитель молний" : "Урон от молний повышен. Молнии бьют еще по 2м целям",
	"Молния смерти" : "При смерти врага выпускает от него 3 молнии",
	"Бомба смерти" : "Наносит урон по области вокруг убитого врага",
	"Лазер смерти" : "Выпускает горизонтальный лазер после смерти врага",
	"Ракета смерти" : "Создает множество снарядов в момент смерти врага",
	"Повелитель технологий" : "Урон от технологий повышается. Атака технологией лечит ОЗ",
	"Оживление" : "После смерти игрока восстанавливает ОЗ в полном объеме",
	"Последний рывок" : "Урон от последнего шара Х300%"
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
var count_get_skill : int = 0
var show_AD = false

func _ready() -> void:
	self.visible = false
	all_skills.append_array(regular)
	all_skills.append_array(rare)
	all_skills.append_array(epic)
	all_skills.append_array(legendary)

func _on_continue_game_pressed() -> void:
	count_get_skill += 1
	if count_get_skill % 3 == 0:
		show_AD = true
	LevelManager.spin_skill -= 1
	if LevelManager.spin_skill <= 0:
		if show_AD:
			YandexSDK.show_interstitial_ad()
			YandexSDK.connect("interstitial_ad", close_ad)
			AudioServer.set_bus_mute(0, true)
			show_AD = false
			return
		LevelManager.spin_skill = 0
		animation.play("windows_output")
	else:
		get_number_skill(LevelManager.spin_skill)

func close_ad(result) -> void:
	if result == "closed" or result == "error":
		AudioServer.set_bus_mute(0, false)
		LevelManager.spin_skill = 0
		animation.play("windows_output")
	elif result == "opened":
		AudioServer.set_bus_mute(0, true)

func get_number_skill(number:int) -> void:
	$Update_skill_button.disabled = true
	for i in windows_skill.get_children():
		i.queue_free()
	skills.clear()
	animation.play("window_input")
	if number == -1:
		create_free_skill()
	else:
		create_skill()

func create_skill():
	var rare_skills = []
	var button_arr = bye_button.get_children()
	skil_for_ad = 0
	sound_scroll.playing = true
	sound_scroll.pitch_scale = 1.1
	$Update_skill_button.visible = false
	for i in windows_skill.get_children():
		i.queue_free()
	for i in bye_button.get_children():
		i.disabled = true
		i.texture_normal = BUTTON_CAN_PRESS_TEXTURE
		for j in i.get_children():
			if "AD" in j.name:
				j.visible = false
			if "FREE" in j.name:
				j.visible = false
			if "Label" in j.name:
				j.visible = true

	var spread = LevelManager.count_experiance * (1 - ((LevelManager.count_experiance - 400) / (23.67 * 100)))
	var min_cost = LevelManager.count_experiance - spread
	var max_cost = LevelManager.count_experiance
	var skill_with_max_cost
	var skill_can_drop = []
	var not_can_buy_skills = []

	var skill_max_cost = -1
	all_skills.shuffle()
	for i in all_skills:
		if !(i[0] in skills_once and i[0] in LevelManager.player_skills): 
			if min_cost <= i[1] and i[1] <= max_cost:
				skill_can_drop.append(i)
				if i[1] > skill_max_cost:
					skill_with_max_cost = i
					skill_max_cost = i[1]
			if i[1] > LevelManager.count_experiance:
				not_can_buy_skills.append(i)
	skill_can_drop.shuffle()
	not_can_buy_skills.shuffle()

	if min_cost < 0:
		min_cost = 0
	if max_cost < 0:
		max_cost = 0

	for i in range(3):
		if skill_can_drop.size() > 0:
			var random_index = randi() % skill_can_drop.size()
			var new_skill = skill_can_drop[random_index]
			if i == 2:
				if (randi() % 100 + 1) <= 30:
					new_skill = skill_with_max_cost
			skills.append(new_skill)
			skill_can_drop.remove_at(random_index)
		else:
			skills.append(not_can_buy_skills[randi() % not_can_buy_skills.size()])
	skills.sort_custom(Callable(self, "compare_skills"))
	if (randi() % 100 + 1) <= 30:
		skills[2] = not_can_buy_skills[randi() % not_can_buy_skills.size()]

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
		button_arr[i].disabled = true
		for j in button_arr[i].get_children():
			if "Button" in j.name:
				j.disabled = true

		if skills[i][1] > LevelManager.count_experiance:
			button_arr[i].texture_normal = BUTTON_NOT_CAN_PRESS_TEXTURE

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
		regular_sound()
		rare_sound()
		epic_sound()
		legendary_sound()
	elif 3 in rare_skills:
		regular_sound()
		rare_sound()
		epic_sound()
	elif 2 in rare_skills:
		regular_sound()
		rare_sound()
	elif 1 in rare_skills:
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
			for j in button_arr[i].get_children():
				if "Button" in j.name:
					j.disabled = false
	$Update_skill_button.visible = true
	if 100 <= LevelManager.count_experiance:
		$Update_skill_button.disabled = false

func legendary_sound() -> void:
	await get_tree().create_timer(2.4).timeout
	$Legendari_skill.play()

func epic_sound() -> void:
	await get_tree().create_timer(1.5).timeout
	$Epic_skill.play()

func rare_sound() -> void:
	await get_tree().create_timer(0.9).timeout
	$Rare_skill.play()

func regular_sound() -> void:
	await get_tree().create_timer(0).timeout
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
			var prosen_hp_plus_ = 0.1
			if "Прибавка к восстановлению" in LevelManager.player_skills:
				prosen_hp_plus_ *= LevelManager.prosen_hp_plus
			LevelManager.hp_player = round(LevelManager.hp_player + (LevelManager.max_hp_player * prosen_hp_plus_))
			LevelManager.max_hp_player = round(LevelManager.max_hp_player * (1 + prosen_hp_plus_))
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
			LevelManager.prosen_hp_plus += 0.5
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

func create_free_skill() -> void:
	var rare_skills = []
	var button_arr = bye_button.get_children()
	skil_for_ad = 0
	sound_scroll.playing = true
	sound_scroll.pitch_scale = 1.1
	$Update_skill_button.visible = false
	for i in windows_skill.get_children():
		i.queue_free()
	for i in bye_button.get_children():
		i.disabled = true
		i.texture_normal = BUTTON_CAN_PRESS_TEXTURE
		for j in i.get_children():
			if "AD" in j.name:
				j.visible = false
	var skill_can_drop = []
	skill_can_drop.append_array(regular)
	skill_can_drop.append_array(rare)
	skill_can_drop.shuffle()
	for i in range(3):
		if skill_can_drop.size() > 0:
			var random_index = randi() % skill_can_drop.size()
			var new_skill = skill_can_drop[random_index]
			skills.append(new_skill)
			skill_can_drop.remove_at(random_index)
	skills.sort_custom(Callable(self, "compare_skills"))
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
	for i in range(skills.size()):
		button_arr[i].disabled = true
		for j in button_arr[i].get_children():
			if "Button" in j.name:
				j.disabled = true

	for i in skills:
		i[1] = 0
	var count : int = 0
	for i in button_arr:
		for j in i.get_children():
			if j.name == "Label":
				j.text = str("БЕСПЛАТНО")
		count += 1

	var time_wait = 0 
	if 2 in rare_skills:
		time_wait = 1.7
	elif 1 in rare_skills:
		time_wait = 1.2

	if 2 in rare_skills:
		regular_sound()
		rare_sound()
	elif 1 in rare_skills:
		regular_sound()

	create_tween().tween_property(sound_scroll, "pitch_scale", 0.9, time_wait - 0.25)
	await get_tree().create_timer(time_wait - 0.25).timeout
	sound_scroll.playing = false
	await get_tree().create_timer(0.25).timeout
	for i in range(skills.size()):
		button_arr[i].disabled = false
		for j in button_arr[i].get_children():
			if "Button" in j.name:
				j.disabled = false

func compare_skills(a, b):
	return a[1] < b[1] 
