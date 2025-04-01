extends MarginContainer

@onready var for_cois = $For_coins
@onready var for_crystal = $For_crystal

@onready var for_coins_texture = $For_coins/Skill_texture
@onready var for_crystal_texture = $For_crystal/Skill_texture

@onready var have_for_coins_talant_texture_line = preload("res://Texture/UI/Talents_UI/синяя полоса.png")
@onready var have_for_crystal_talant_texture_line = preload("res://Texture/UI/Talents_UI/золотая полоса.png")

var can_bye : bool = true
var bye : bool = false
var need_level_to_by : int = 0

var count_skill_for_coins
var count_skill_for_crystal 

var can_close_information = true
var skill_for_crystal
var skill_for_coins

var skill_for_crystal_cost : int = 0
var skill_for_coins_cost : int = 0

var for_crystal_talent_texture = {
	"Дополнительный навык при старте боя": preload("res://Texture/UI/Talents_UI/Talent_texture/Дополнительный навык при старте боя.png"),
	"Дополнительные монеты в начале боя": preload("res://Texture/UI/Talents_UI/Talent_texture/Дополнительные монеты в начале боя.png"),
	"Атака +5%": preload("res://Texture/UI/Talents_UI/Talent_texture/Атака +Х_.png"),
	"1% нанести в 10 раз больше урона": preload("res://Texture/UI/Talents_UI/Talent_texture/1_ нанести в 10 раз больше урона.png"),
	"Урон по боссу на 10% больше": preload("res://Texture/UI/Talents_UI/Talent_texture/Урон по боссу на Х_ больше.png"),
	"10% шанс при взятии “+1 шар” получить 2 шара": preload("res://Texture/UI/Talents_UI/Talent_texture/10_ шанс при взятии “+1 шар” получить 2 шара.png"),
	"0,1% нанести в 100 раз больше урона": preload("res://Texture/UI/Talents_UI/Talent_texture/1_ нанести в 10 раз больше урона.png"),
	"ОЗ +5%": preload("res://Texture/UI/Talents_UI/Talent_texture/ОЗ +Х_.png")}

var discription_talants = {
	"Дополнительный навык при старте боя": "Обычный или редкий скилл при старте уровня",
	"Дополнительные монеты в начале боя": "Увеличение заработка монет",
	"Атака +5%": "Увеличивает весь урон на 5% от текущего урона",
	"1% нанести в 10 раз больше урона": "+1% шанс при каждом попадании нанести в 10 раз больше урона",
	"Урон по боссу на 10% больше": "Увеличивает урон по боссу на 10%",
	"10% шанс при взятии “+1 шар” получить 2 шара": "+10% шанс при взятии “+1 шар” получить 2 шара",
	"0,1% нанести в 100 раз больше урона": "+0.1% шанс при каждом попадании нанести в 100 раз больше урона",
	"ОЗ +5%": "Увеличивает ОЗ на 5%"}

var skills_for_crystall = [
	"Атака +5%",
	"1% нанести в 10 раз больше урона",
	"Урон по боссу на 10% больше",
	"10% шанс при взятии “+1 шар” получить 2 шара",
	"0,1% нанести в 100 раз больше урона",
	"ОЗ +5%"]

var skills_for_coins = [
	"Увеличение атаки",
	"Увеличение здоровья",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Урон от врагов дальнего боя",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Улучшение восстановления",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Урон от врагов ближнего боя",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Улучшение регенерации",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Увеличение атаки",
	"Увеличение здоровья",
	"Урон от БОССА"]

func erase_for_crystal() -> void:
	for_crystal.disabled = true
	for_crystal.visible = false

func for_coins_update_texture_and_discriotion(skill, count_skills, discription, texture) -> void:
	count_skill_for_coins = count_skills
	skill_for_coins_cost = 500 + (1250 * ((count_skill_for_coins - 1) / 5))
	for_coins_texture.texture = texture
	if count_skill_for_coins <= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_COINS:
		$For_coins/TextureRect3.texture = have_for_coins_talant_texture_line
	update_discription_for_coins(skill, discription)

func for_crystal_update_texture_and_discriotion(count) -> void:
	var talant
	if count == 1:
		count_skill_for_crystal = 1
		for_crystal_texture.texture = for_crystal_talent_texture["Дополнительный навык при старте боя"]
		talant = "Дополнительный навык при старте боя"
		skill_for_crystal_cost = 200
		$For_crystal/TextureRect.scale = Vector2(1, 0.8)
	elif count == 6:
		count_skill_for_crystal = 2
		for_crystal_texture.texture = for_crystal_talent_texture["Дополнительные монеты в начале боя"]
		skill_for_crystal_cost = 200
		talant = "Дополнительные монеты в начале боя"
	else:
		count = count / 6
		count_skill_for_crystal = count + 1
		count -= 2
		for_crystal_texture.texture = for_crystal_talent_texture[skills_for_crystall[count % 6]]
		talant = skills_for_crystall[count % 6]
		skill_for_crystal_cost = 300 * (((count_skill_for_crystal - 3) / 6) + 1)
	if count_skill_for_crystal <= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL:
		$For_crystal/TextureRect.texture = have_for_crystal_talant_texture_line
	update_discription_for_crystal(talant)

func update_discription_for_crystal(talant) -> void:
	$For_crystal/Information/Skill_name.text = talant
	$For_crystal/Information/Discription.text = discription_talants[talant]

func update_discription_for_coins(talant, discription) -> void:
	$For_coins/Information/Skill_name.text = talant
	$For_coins/Information/Discription.text = discription + add_discription_coins(count_skill_for_coins, talant)

func add_discription_coins(num_talant, name_talant) -> String:
	var add_discripton = ""
	var count_talant : int = 1
	var result_talant : float = 0
	for i in range(num_talant+1):
		if skills_for_coins[i % 25] == name_talant:
			match skills_for_coins[i % 25]:
				"Увеличение атаки":
					result_talant = 0.2 * count_talant
					count_talant += 1
				"Увеличение здоровья":
					result_talant = 50 * count_talant
					count_talant += 1
				"Урон от врагов дальнего боя":
					result_talant = 20 * count_talant
					count_talant += 1
				"Урон от врагов ближнего боя":
					result_talant = 100 * count_talant
					count_talant += 1
				"Улучшение восстановления":
					result_talant = 50 * count_talant
					count_talant += 1
				"Улучшение регенерации":
					result_talant = 20 * count_talant
					count_talant += 1
				"Урон от БОССА":
					result_talant = 20 * count_talant
					count_talant += 1

	match name_talant:
		"Увеличение атаки":
			add_discripton = "+" + str(result_talant * 100)
		"Увеличение здоровья":
			add_discripton = "+" + str(result_talant)
		"Урон от врагов дальнего боя":
			add_discripton = "-" + str(result_talant)
		"Урон от врагов ближнего боя":
			add_discripton = "-" + str(result_talant)
		"Улучшение восстановления":
			add_discripton = "+" + str(result_talant)
		"Улучшение регенерации":
			add_discripton = "+" + str(result_talant)
		"Урон от БОССА":
			add_discripton = "-" + str(result_talant)
	return add_discripton

func skills_close(zamoc, texture_for_coins, texture_for_crystal) -> void:
	for_cois.texture_normal = texture_for_coins
	for_coins_texture.texture = zamoc
	for_crystal.texture_normal = texture_for_crystal
	for_crystal_texture.texture = zamoc
	can_bye = false

func update_need_level(lvl) -> void:
	need_level_to_by = lvl

func _on_button_for_coins_pressed() -> void:
	AudioManager.click()
	can_close_information = false
	$Timer_can_close.start()
	$For_coins/Information.visible = true
	$For_coins/Information/Need_level.visible = false
	$For_coins/Information/Bye_skill.visible = false
	$For_coins/Information/Have_this_skill.visible = false
	$For_coins/Information/Need_previous_skill.visible = false
	$For_coins/Information/Skill_name.visible = false
	$For_coins/Information/Discription.visible = false
	if PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_coins <= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_COINS:
		$For_coins/Information/Have_this_skill.visible = true
		$For_coins/Information/Skill_name.visible = true
		$For_coins/Information/Discription.visible = true
	elif PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_coins == PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_COINS + 1:
		$For_coins/Information/Bye_skill.visible = true
		$For_coins/Information/Skill_name.visible = true
		$For_coins/Information/Discription.visible = true
		$For_coins/Information/Bye_skill/Label.text = str(skill_for_coins_cost)
	elif PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_coins >= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_COINS + 2:
		$For_coins/Information/Need_previous_skill.visible = true
		$For_coins/Information/Discription.visible = true
		$For_coins/Information/Skill_name.visible = true
	elif bye == false and can_bye == false:
		$For_coins/Information/Need_level.visible = true
		$For_coins/Information/Need_level.text = "Требуется уровень " + str(need_level_to_by)

func _on_button_for_crystall_pressed() -> void:
	AudioManager.click()
	can_close_information = false
	$Timer_can_close.start()
	$For_crystal/Information.visible = true
	$For_crystal/Information/Need_level.visible = false
	$For_crystal/Information/Bye_skill.visible = false
	$For_crystal/Information/Have_this_skill.visible = false
	$For_crystal/Information/Need_previous_skill.visible = false
	$For_crystal/Information/Skill_name.visible = false
	$For_crystal/Information/Discription.visible = false
	if PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_crystal <= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL:
		$For_crystal/Information/Have_this_skill.visible = true
		$For_crystal/Information/Discription.visible = true
	elif PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_crystal == PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL + 1:
		$For_crystal/Information/Bye_skill.visible = true
		$For_crystal/Information/Discription.visible = true
		$For_crystal/Information/Bye_skill/Label.text = str(skill_for_crystal_cost)
	elif PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_crystal >= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL + 2:
		$For_crystal/Information/Need_previous_skill.visible = true
		$For_crystal/Information/Discription.visible = true
	elif bye == false and can_bye == false:
		$For_crystal/Information/Need_level.visible = true
		$For_crystal/Information/Need_level.text = "Требуется уровень " + str(need_level_to_by)

func information_close() -> void:
	if can_close_information:
		$For_crystal/Information.visible = false
		$For_coins/Information.visible = false

func _on_timer_can_close_timeout() -> void:
	can_close_information = true

func _on_bye_for_crystal_pressed() -> void:
	AudioManager.click()
	if PlayerIndicatorsManager.CRYSTALS_COUNT >= skill_for_crystal_cost:
		$For_crystal/Information.visible = false
		$For_coins/Information.visible = false
		AudioManager.click()
		AudioManager.bye_talant_sound()
		PlayerIndicatorsManager.buy_crystal_talant()
		PlayerIndicatorsManager.update_crystal_count(-skill_for_crystal_cost)
		$For_crystal/TextureRect.texture = have_for_crystal_talant_texture_line
		get_parent().get_parent().get_parent().call("update_player_indicator_talant_for_coins")
		get_parent().get_parent().get_parent().get_parent().call("update_crystal_label")
		get_parent().get_parent().get_parent().get_parent().call("can_by_new_talant")

func _on_bye_for_cois_pressed() -> void:
	AudioManager.click()
	if PlayerIndicatorsManager.COINS_COUNT >= skill_for_coins_cost:
		$For_crystal/Information.visible = false
		$For_coins/Information.visible = false
		AudioManager.bye_talant_sound()
		PlayerIndicatorsManager.buy_coins_talant()
		PlayerIndicatorsManager.update_coins_count(-skill_for_coins_cost)
		$For_coins/TextureRect3.texture = have_for_coins_talant_texture_line
		get_parent().get_parent().get_parent().call("update_player_indicator_talant_for_coins")
		get_parent().get_parent().get_parent().get_parent().call("update_coins_label")
		get_parent().get_parent().get_parent().get_parent().call("can_by_new_talant")

func _on_bye_button_mouse_entered() -> void:
	can_close_information = false

func _on_bye_button_mouse_exited() -> void:
	can_close_information = true
