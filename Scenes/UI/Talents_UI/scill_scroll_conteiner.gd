extends MarginContainer

@onready var for_cois = $For_coins
@onready var for_crystal = $For_crystal

@onready var for_coins_texture = $For_coins/Skill_texture
@onready var for_crystal_texture = $For_crystal/Skill_texture

@onready var skill_for_coins_close_texture = preload("res://Texture/UI/Talents_UI/ячейка неактивная для талантов за монеты.png")
@onready var skill_for_crystal_close_texture = preload("res://Texture/UI/Talents_UI/серая ячейка (для золотой).png")
@onready var close_texture = preload("res://Texture/UI/Talents_UI/замок.png")

var can_bye : bool = true
var bye : bool = false
var need_level_to_by : int = 0

var can_close_information = true

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

func for_coins_update_texture_and_discriotion(skill) -> void:
	for_coins_texture.texture = for_coins_talent_texture[skill]

func for_crystal_update_texture_and_discriotion(count) -> void:
	if count == 1:
		for_crystal_texture.texture = for_crystal_talent_texture["Дополнительный навык при старте боя"]
	elif count == 6:
		for_crystal_texture.texture = for_crystal_talent_texture["Дополнительные монеты в начале боя"]
	else:
		count = count / 6
		count -= 2
		for_crystal_texture.texture = for_crystal_talent_texture[skills_for_crystall[count % 6]]

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
	if bye:
		$For_coins/Information/Have_this_skill.visible = true
	elif bye == false and can_bye == true:
		$For_coins/Information/Bye_skill.visible = true
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
	if bye:
		$For_crystal/Information/Have_this_skill.visible = true
	elif bye == false and can_bye == true:
		$For_crystal/Information/Bye_skill.visible = true
	elif bye == false and can_bye == false:
		$For_crystal/Information/Need_level.visible = true
		$For_crystal/Information/Need_level.text = "Требуется уровень " + str(need_level_to_by)

func information_close() -> void:
	if can_close_information:
		$For_crystal/Information.visible = false
		$For_coins/Information.visible = false

func _on_timer_can_close_timeout() -> void:
	can_close_information = true
