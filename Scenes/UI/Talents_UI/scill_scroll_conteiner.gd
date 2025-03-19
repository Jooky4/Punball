extends MarginContainer

@onready var for_cois = $For_coins
@onready var for_crystal = $For_crystal

@onready var for_coins_texture = $For_coins/Skill_texture
@onready var for_crystal_texture = $For_crystal/Skill_texture

@onready var skill_for_coins_close_texture = preload("res://Texture/UI/Talents_UI/ячейка неактивная для талантов за монеты.png")
@onready var skill_for_crystal_close_texture = preload("res://Texture/UI/Talents_UI/серая ячейка (для золотой).png")
@onready var close_texture = preload("res://Texture/UI/Talents_UI/замок.png")
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

var for_coins_talent_texture = {
	"Увеличение атаки": preload("res://Texture/UI/Talents_UI/Talent_texture/увеличение атаки.png"),
	"Увеличение ОЗ": preload("res://Texture/UI/Talents_UI/Talent_texture/увеличение ОЗ.png"),
	"Уменьшение урона от дальних врагов": preload("res://Texture/UI/Talents_UI/Talent_texture/уменьшение урона дальнийбой.png"),
	"Улучшение восстановления": preload("res://Texture/UI/Talents_UI/Talent_texture/улучшение эффекта восстановления.png"),
	"Уменьшение урона от ближних врагов": preload("res://Texture/UI/Talents_UI/Talent_texture/уменьшение урона ближний бой.png"),
	"Регенерация": preload("res://Texture/UI/Talents_UI/Talent_texture/регенерация.png"),
	"Увеличение урона от босса": preload("res://Texture/UI/Talents_UI/Talent_texture/Урон по боссу на Х_ больше.png")}

var for_crystal_talent_texture = {
	"Дополнительный навык при старте боя": preload("res://Texture/UI/Talents_UI/Talent_texture/Дополнительный навык при старте боя.png"),
	"Дополнительные монеты в начале боя": preload("res://Texture/UI/Talents_UI/Talent_texture/Дополнительные монеты в начале боя.png"),
	"Атака +5%": preload("res://Texture/UI/Talents_UI/Talent_texture/Атака +Х_.png"),
	"1% нанести в 10 раз больше урона": preload("res://Texture/UI/Talents_UI/Talent_texture/1_ нанести в 10 раз больше урона.png"),
	"Урон по боссу на 10% больше": preload("res://Texture/UI/Talents_UI/Talent_texture/Урон по боссу на Х_ больше.png"),
	"5% шанс при взятии “+1 шар” получить 2 шара": preload("res://Texture/UI/Talents_UI/Talent_texture/регенерация.png"),
	"0,1% нанести в 100 раз больше урона": preload("res://Texture/UI/Talents_UI/Talent_texture/1_ нанести в 10 раз больше урона.png"),
	"ОЗ +5%": preload("res://Texture/UI/Talents_UI/Talent_texture/ОЗ +Х_.png")}

var discription_talants = {
	"Увеличение атаки": "Атака + 50",
	"Увеличение ОЗ": "ОЗ +500",
	"Уменьшение урона от дальних врагов": "Уменьшение урона на 100",
	"Улучшение восстановления": "Дополнительно +50 ОЗ",
	"Уменьшение урона от ближних врагов": "Уменьшение урона на 100",
	"Регенерация": "Каждую волну, кроме волн на боссе +50 ОЗ",
	"Увеличение урона от босса": "",
	"Дополнительный навык при старте боя": "Обычный или редкий скилл при старте уровня",
	"Дополнительные монеты в начале боя": "Подучашь дополнительные монеты",
	"Атака +5%": "Увеличивает весь урон на 5% от текущего урона",
	"1% нанести в 10 раз больше урона": "+1% шанс при каждом попадании нанести в 10 раз больше урона",
	"Урон по боссу на 10% больше": "Увеличивает урон по боссу на 10%",
	"5% шанс при взятии “+1 шар” получить 2 шара": "+10% шанс при взятии “+1 шар” получить 2 шара",
	"0,1% нанести в 100 раз больше урона": "+0.1% шанс при каждом попадании нанести в 100 раз больше урона",
	"ОЗ +5%": "Увеличивает ОЗ на 5%"}

var skills_for_crystall = [
	"Атака +5%",
	"1% нанести в 10 раз больше урона",
	"Урон по боссу на 10% больше",
	"5% шанс при взятии “+1 шар” получить 2 шара",
	"0,1% нанести в 100 раз больше урона",
	"ОЗ +5%"]

func erase_for_crystal() -> void:
	for_crystal.disabled = true
	for_crystal.visible = false

func for_coins_update_texture_and_discriotion(skill, count_skills) -> void:
	count_skill_for_coins = count_skills
	skill_for_coins_cost = 500 + (1250 * ((count_skill_for_coins - 1) / 5))
	for_coins_texture.texture = for_coins_talent_texture[skill]
	if count_skill_for_coins <= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_COINS:
		$For_coins/TextureRect3.texture = have_for_coins_talant_texture_line
	update_discription_for_coins(skill)

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

func update_discription_for_coins(talant) -> void:
	$For_coins/Information/Skill_name.text = talant
	$For_coins/Information/Discription.text = discription_talants[talant]

func skills_close() -> void:
	for_cois.texture_normal = skill_for_coins_close_texture
	for_coins_texture.texture = close_texture
	for_crystal.texture_normal = skill_for_crystal_close_texture
	for_crystal_texture.texture = close_texture
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
		$For_coins/Information/Bye_skill/Bye_Button/Label.text = str(skill_for_coins_cost)
	elif PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_coins >= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_COINS + 2:
		$For_coins/Information/Bye_skill.visible = true
		$For_coins/Information/Skill_name.visible = true
		$For_coins/Information/Discription.visible = true
		$For_coins/Information/Bye_skill/Bye_Button/Label.text = str(skill_for_coins_cost)
		#$For_coins/Information/Need_previous_skill.visible = true
		#$For_coins/Information/Discription.visible = true
		#$For_coins/Information/Skill_name.visible = true
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
		$For_crystal/Information/Skill_name.visible = true
		$For_crystal/Information/Discription.visible = true
	elif PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_crystal == PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL + 1:
		$For_crystal/Information/Bye_skill.visible = true
		$For_crystal/Information/Skill_name.visible = true
		$For_crystal/Information/Discription.visible = true
		$For_crystal/Information/Bye_skill/Bye_Button/Label.text = str(skill_for_crystal_cost)
	elif PlayerIndicatorsManager.LEVEL_PLAYER >= need_level_to_by and count_skill_for_crystal >= PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL + 2:
		$For_crystal/Information/Bye_skill.visible = true
		$For_crystal/Information/Skill_name.visible = true
		$For_crystal/Information/Discription.visible = true
		$For_crystal/Information/Bye_skill/Bye_Button/Label.text = str(skill_for_crystal_cost)
		#$For_crystal/Information/Need_previous_skill.visible = true
		#$For_crystal/Information/Discription.visible = true
		#$For_crystal/Information/Skill_name.visible = true
	elif bye == false and can_bye == false:
		$For_crystal/Information/Need_level.visible = true
		$For_crystal/Information/Need_level.text = "Требуется уровень " + str(need_level_to_by)

func information_close() -> void:
	if can_close_information:
		$For_crystal/Information.visible = false
		$For_coins/Information.visible = false

func _on_timer_can_close_timeout() -> void:
	can_close_information = true
