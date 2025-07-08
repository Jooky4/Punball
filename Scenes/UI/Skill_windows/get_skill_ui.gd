extends Control

var SKILL_WINDOW = preload("res://Scenes/UI/Skill_windows/skill_window.tscn")
var BUTTON_NOT_CAN_PRESS_TEXTURE = preload("res://Texture/UI/Skills_UI/disabled_buy_button.tres")
var BUTTON_CAN_PRESS_TEXTURE = preload("res://Texture/UI/Skills_UI/buy_button.tres")

var BUTTON_UPDATE_SKILL_CAN_PRESS_TEXTURE = preload("res://Texture/UI/Skills_UI/enabled_reroll_button.tres")
var BUTTON_UPDATE_SKILL_NOT_PRESS_TEXTURE = preload("res://Texture/UI/Skills_UI/disabled_reroll_button.tres")

@onready var windows_skill = $Windows_skill
@onready var animation = $AnimationPlayer
@onready var bye_button = $Bye_button
@onready var sound_scroll = $Get_skill_scrolling
var skil_for_ad = 0
var regular = [
	["Шар-заморозка", 200],
	["Лед: комбо", 180],
	["Ядерная: комбо", 110],
	["Прибавка к восстановлению", 0],
	["Прибавка ОЗ", 0],
	["Усиление обычного шара", 100]
]
var rare = [
	["Огненный шар", 400],
	["Шар-бомба", 450],
	["Бомба-заморозка", 480],
	["Молния: комбо", 210],
	["Лазер: комбо", 250],
	["Огонь: комбо", 250],
	["Кумулятивный шар", 500],
	["Шар удара в спину", 460],
	["Шар убийца", 490],
	["Технология: комбо с тыла", 210],
	["Технология: комбо с фронта", 210],
	["Усиление особого шара", 280],
	["Усиление атаки", 490],
	["Комбо: скидка", 260],
	["Суперначало", 390]
]
var epic = [
	["Шар молний",  600],
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
	["Повелитель молний", 970]
]
var legendary = [
	["Молния смерти", 1220],
	["Бомба смерти", 1220],
	["Лазер смерти", 1220],
	["Ракета смерти", 1220],
	["Повелитель технологий", 1380],
	["Оживление", 1820],
	["Последний рывок", 1320]
]


var skill_discription = {
	"Шар-заморозка": tr("SKILL_DESC_FREEZE_BALL"),
	"Лед: комбо": tr("SKILL_DESC_ICE_COMBO"),
	"Ядерная: комбо": tr("SKILL_DESC_NUKE_COMBO"),
	"Прибавка к восстановлению": tr("SKILL_DESC_INC_HP_RECOVERY"),
	"Прибавка ОЗ": tr("SKILL_DESC_INC_MAX_HP"),
	"Усиление обычного шара": tr("SKILL_DESC_NORMAL_BALL_BOOST"),
	"Огненный шар": tr("SKILL_DESC_FIRE_BALL"),
	"Шар-бомба": tr("SKILL_DESC_BOMB_BALL"),
	"Бомба-заморозка": tr("SKILL_DESC_FREEZE_BOMB"),
	"Молния: комбо": tr("SKILL_DESC_LIGHTING_COMBO"),
	"Лазер: комбо": tr("SKILL_DESC_LASER_COMBO"),
	"Огонь: комбо": tr("SKILL_DESC_FIRE_COMBO"),
	"Кумулятивный шар": tr("SKILL_DESC_POWER_BALL"),
	"Шар удара в спину": tr("SKILL_DESC_BACKSTAB_BALL"),
	"Шар убийца": tr("SKILL_DESC_KILLER_BALL"),
	"Технология: комбо с тыла": tr("SKILL_DESC_BACKLINE_TECH"),
	"Технология: комбо с фронта": tr("SKILL_DESC_FRONTLINE_TECH"),
	"Усиление особого шара": tr("SKILL_DESC_SPECIAL_BALL_BOOST"),
	"Усиление атаки": tr("SKILL_DESC_DAMAGE_BOOST"),
	"Комбо: скидка": tr("SKILL_DESC_COMBO_SKILLS"),
	"Суперначало": tr("SKILL_DESC_SUPER_START"),
	"Шар молний": tr("SKILL_DESC_LIGHTING_BALL"),
	"Повелитель льда": tr("SKILL_DESC_ICE_MASTER"),
	"Повелитель огня": tr("SKILL_DESC_FIRE_MASTER"),
	"Рассыпающийся шар": tr("SKILL_DESC_SPLITTING_BALL"),
	"Вертикальный лазерный шар": tr("SKILL_DESC_VERTICAL_LASER_BALL"),
	"Горизонтальный лазерный шар": tr("SKILL_DESC_HORIZONTAL_LASER_BALL"),
	"Повелитель лазера": tr("SKILL_DESC_LASER_MASTER"),
	"Шар ракета": tr("SKILL_DESC_ROCKET_BALL"),
	"Повелитель атома": tr("SKILL_DESC_ROCKET_MASTER"),
	"Бурящий шар": tr("SKILL_DESC_PIERCING_BALL"),
	"Ловушка": tr("SKILL_DESC_TRAP"),
	"Холод смерти": tr("SKILL_DESC_DEATH_CHILL"),
	"Повелитель молний": tr("SKILL_DESC_LIGHTING_MASTER"),
	"Молния смерти": tr("SKILL_DESC_DEATH_LIGHTING"),
	"Бомба смерти": tr("SKILL_DESC_DEATH_BOMB"),
	"Лазер смерти": tr("SKILL_DESC_DEATH_LASER"),
	"Ракета смерти": tr("SKILL_DESC_DEATH_ROCKETS"),
	"Повелитель технологий": tr("SKILL_DESC_TECH_MASTER"),
	"Оживление": tr("SKILL_DESC_REVIVE"),
	"Последний рывок": tr("SKILL_DESC_LAST_PUSH"),
}

var skills = []
var all_skills = []
var skills_once = [
	"Молния смерти",
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
	"Комбо: скидка"
]
var skill_from_spesific_location = {
	"Лед: комбо": 2,
	"Огонь: комбо": 2,
	"Ядерная: комбо": 2,
	"Молния: комбо": 3,
	"Технология: комбо с тыла": 3,
	"Технология: комбо с фронта": 3,
	"Лазер: комбо": 4,
	"Комбо: скидка": 4
}
var count_get_skill : int = 0
var show_AD = false


signal skill_taken(skill)
signal update_skill
signal update_exp


func _ready() -> void:
	for i in windows_skill.get_children():
		i.queue_free()
	skills.clear()
	all_skills.append_array(regular)
	all_skills.append_array(rare)
	all_skills.append_array(epic)
	all_skills.append_array(legendary)
	#YandexSDK.connect("interstitial_ad", close_ad)
	GP.Ads.fullscreen_close.connect(_close_ad)
	#YandexSDK.connect("rewarded_ad", rew_ad_res)
	GP.Ads.rewarded_start.connect(_rew_ad_opened)
	GP.Ads.rewarded_close.connect(_rew_ad_closed)
	GP.Ads.rewarded_reward.connect(rew_ad_res.bind("rewarded"))
	self.visible = false


func _on_continue_game_pressed() -> void:
	for i in windows_skill.get_children():
		i.queue_free()

	skills.clear()

	count_get_skill += 1
	if count_get_skill % 3 == 0:
		show_AD = true
	LevelManager.spin_skill -= 1

	if LevelManager.spin_skill <= 0:
		if show_AD:
			#YandexSDK.show_interstitial_ad()
			GP.Ads.show_fullscreen()
			AudioServer.set_bus_mute(0, true)
			return
		else:
			LevelManager.spin_skill = 0
			animation.play("windows_output")
			skill_taken.emit(0)
	else:
		get_number_skill(LevelManager.spin_skill)
		update_exp.emit()


func _close_ad(success: bool) -> void:
	close_ad("closed")


func close_ad(result) -> void:
	if show_AD:
		if result == "closed" or result == "error":
			show_AD = false
			AudioServer.set_bus_mute(0, false)
			LevelManager.spin_skill = 0
			animation.play("windows_output")
			skill_taken.emit(0)
		elif result == "opened":
			AudioServer.set_bus_mute(0, true)


func get_number_skill(number:int) -> void:
	animation.play("window_input")
	$Update_skill_button.disabled = true
	for i in windows_skill.get_children():
		i.queue_free()
	skills.clear()

	YandexMetrika.ym(101336789,'reachGoal','skill_start_roll')

	if number == -1:
		create_free_skill()
	else:
		create_skill()


func create_skill():
	for i in windows_skill.get_children():
		i.queue_free()
	skills.clear()
	skills = []
	var rare_skills = []
	var button_arr = bye_button.get_children()
	skil_for_ad = 0
	sound_scroll.playing = true
	sound_scroll.pitch_scale = 1.1

	$Update_skill_button.visible = false
	if 100 <= LevelManager.count_experiance:
		$Update_skill_button.texture_normal = BUTTON_UPDATE_SKILL_CAN_PRESS_TEXTURE
	else:
		$Update_skill_button.texture_normal = BUTTON_UPDATE_SKILL_NOT_PRESS_TEXTURE

	for i in button_arr:
		i.disabled = true
		i.visible = false
		i.texture_normal = BUTTON_CAN_PRESS_TEXTURE
		for j in i.get_children():
			if "AD" in j.name:
				j.visible = false
			if "FREE" in j.name:
				j.visible = false
			if "Label" in j.name:
				j.visible = true

	var spread = int(LevelManager.count_experiance * (1 - ((LevelManager.count_experiance - 400) / (23.67 * 100))))
	var min_cost = int(LevelManager.count_experiance - spread)
	var max_cost = LevelManager.count_experiance
	var skill_with_max_cost
	var skill_can_drop = []
	var not_can_buy_skills = []
	if max_cost > 1820:
		min_cost = 1000
	if min_cost <= 0:
		min_cost = 0
	var skill_max_cost = -1
	for i in all_skills:
		if i[0] in skills_once:
			if i[0] not in LevelManager.player_skills:
				if min_cost <= i[1] and i[1] <= max_cost:
					skill_can_drop.append(i)
					if i[1] > skill_max_cost:
						if i[0] in skill_from_spesific_location.keys():
							if WaveGeneration.current_location >= skill_from_spesific_location[i[0]]:
								skill_with_max_cost = i
								skill_max_cost = i[1]
						else:
							skill_with_max_cost = i
							skill_max_cost = i[1]
				if i[1] > LevelManager.count_experiance:
					not_can_buy_skills.append(i)
		else:
			if min_cost <= i[1] and i[1] <= max_cost:
				skill_can_drop.append(i)
				if i[1] > skill_max_cost:
					skill_with_max_cost = i
					skill_max_cost = i[1]
			if i[1] > LevelManager.count_experiance:
				not_can_buy_skills.append(i)
	skill_can_drop = delete_skill_for_this_location(skill_can_drop)
	not_can_buy_skills = delete_skill_for_this_location(not_can_buy_skills)
	for i in range(3):
		if skill_can_drop.size() > 0:
			var random_index = randi() % skill_can_drop.size()
			var new_skill = skill_can_drop[random_index]
			if i == 2 and skill_with_max_cost:
				if skill_with_max_cost not in skills:
					if (randi() % 100 + 1) <= 30:
						new_skill = skill_with_max_cost
			skills.append(new_skill)
			skill_can_drop.remove_at(random_index)
		else:
			if not_can_buy_skills.size() > 0:
				skills.append(not_can_buy_skills[randi() % not_can_buy_skills.size()])
	if (randi() % 100 + 1) <= 30 and not_can_buy_skills.size() >= 1:
		skills[2] = not_can_buy_skills[randi() % not_can_buy_skills.size()]

	skills = bubble_sort(skills)
	for i in skills:
		var buff = SKILL_WINDOW.instantiate()
		windows_skill.add_child(buff)
		# TODO
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

	for i in range(button_arr.size()):
		for j in button_arr[i].get_children():
			if j.name == "FREE" and skills[i][1] == 0:
				j.visible = true

			if j.name == "Label":
				j.text = str(skills[i][1])

				if skills[i][1] == 0:
					j.visible = false

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
		button_arr[i].visible = true
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


func delete_skill_for_this_location(arr_skill):
	var finish_arr = []
	for i in arr_skill:
		if i[0] in skill_from_spesific_location.keys():
			if WaveGeneration.current_location >= skill_from_spesific_location[i[0]]:
				finish_arr.append(i)
		else:
			finish_arr.append(i)
	return finish_arr


func legendary_sound() -> void:
	await get_tree().create_timer(2.4).timeout
	AudioManager.play_sound("legendary_skill")


func epic_sound() -> void:
	await get_tree().create_timer(1.5).timeout
	AudioManager.play_sound("epic_skill")


func rare_sound() -> void:
	await get_tree().create_timer(0.9).timeout
	AudioManager.play_sound("rare_skill")


func regular_sound() -> void:
	await get_tree().create_timer(0).timeout
	AudioManager.play_sound("regular_skill")


func _on_skill_1_pressed() -> void:
	AudioManager.click()

	YandexMetrika.ym(101336789,'reachGoal','taken_skill_after_reroll')

	if $Bye_button/Skill_1/FREE.visible:
		add_skill(skills[0][0])
	else:
		LevelManager.buy_skill(skills[0][1])
		add_skill(skills[0][0])


func _on_skill_2_pressed() -> void:
	AudioManager.click()

	YandexMetrika.ym(101336789,'reachGoal','taken_skill_after_reroll')

	if $Bye_button/Skill_2/FREE.visible:
		add_skill(skills[1][0])
	else:
		LevelManager.buy_skill(skills[1][1])
		add_skill(skills[1][0])


func _on_skill_3_pressed() -> void:
	AudioManager.click()

	YandexMetrika.ym(101336789,'reachGoal','taken_skill_after_reroll')

	if $Bye_button/Skill_3/FREE.visible:
		add_skill(skills[2][0])
	else:
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
			var count_bust_hp = LevelManager.player_skills.count("Прибавка к восстановлению")
			if count_bust_hp != 0:
				prosen_hp_plus_ *= 1 + (count_bust_hp * 0.5)
			LevelManager.hp_player = round(LevelManager.hp_player + (LevelManager.max_hp_player * prosen_hp_plus_))
			LevelManager.max_hp_player = round(LevelManager.max_hp_player * (1 + prosen_hp_plus_))
			if LevelManager.hp_player >= LevelManager.max_hp_player:
				LevelManager.hp_player = LevelManager.max_hp_player
			LevelManager.hp_player = round(LevelManager.hp_player)
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
		AudioManager.click()
		LevelManager.buy_skill(100)
		update_skill.emit()
		for i in windows_skill.get_children():
			i.queue_free()
		skills.clear()
		create_skill()

func _on_skill_for_ad_pressed(extra_arg_0: int) -> void:
	AudioManager.click()
	AudioServer.set_bus_mute(0, true)
	skil_for_ad = extra_arg_0
	#YandexSDK.gameplay_stopped()
	GP.Game.pause()
	#YandexSDK.show_rewarded_ad()
	GP.Ads.show_rewarded_video()


func _rew_ad_opened() -> void:
	rew_ad_res("opened")


func _rew_ad_closed(success: bool) -> void:
	rew_ad_res("closed")


func rew_ad_res(result:String) -> void:
	if result == "closed" or result == "error":
		AudioServer.set_bus_mute(0, false)
		#YandexSDK.gameplay_started()
		GP.Game.resume()
	elif result == "rewarded":
		LevelManager.buy_skill(LevelManager.count_experiance)
		add_skill(skills[skil_for_ad][0])
	elif result == "opened":
		AudioServer.set_bus_mute(0, true)


func create_free_skill() -> void:
	for i in windows_skill.get_children():
		i.queue_free()
	skills.clear()
	var rare_skills = []
	var button_arr = bye_button.get_children()
	sound_scroll.playing = true
	sound_scroll.pitch_scale = 1.1
	$Update_skill_button.visible = false
	for i in bye_button.get_children():
		i.disabled = true
		i.texture_normal = BUTTON_CAN_PRESS_TEXTURE
		for j in i.get_children():
			if "AD" in j.name:
				j.visible = false
	var skill_can_drop = []
	skill_can_drop.append_array(regular)
	skill_can_drop.append_array(rare)
	skill_can_drop = delete_skill_for_this_location(skill_can_drop)
	for i in range(3):
		if skill_can_drop.size() > 0:
			var random_index = randi() % skill_can_drop.size()
			var new_skill = skill_can_drop[random_index]
			skills.append(new_skill)
			skill_can_drop.remove_at(random_index)
	skills = bubble_sort(skills)
	for i in skills:
		var buff = SKILL_WINDOW.instantiate()
		windows_skill.add_child(buff)
		# TODO
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

	for i in button_arr:
		for j in i.get_children():
			if j.name == "Label":
				j.text = tr("BTN_FREE")

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

func bubble_sort(arr: Array) -> Array:
	var n = arr.size()
	for i in range(n):
		for j in range(0, n - i - 1):
			if arr[j][1] > arr[j + 1][1]:
				var temp = arr[j]
				arr[j] = arr[j + 1]
				arr[j + 1] = temp
	return arr
