extends Control

@onready var empty_container = preload("res://Scenes/UI/Talents_UI/buff.tscn")

@onready var level_scroll_conteiner = preload("res://Scenes/UI/Talents_UI/level_scroll_conteiner.tscn")
@onready var scill_scroll_conteiner = preload("res://Scenes/UI/Talents_UI/scill_scroll_conteiner.tscn")

@onready var level_scroll = $Lvl_ScrollContainer
@onready var skill_scroll = $Scill_ScrollContainer

@onready var skills_container = $Scill_ScrollContainer/Skills_container
@onready var level_container = $Lvl_ScrollContainer/Level_container

var can_ubdate_skill = true

var skills_for_coins = [
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Уменьшение урона от дальних врагов",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Улучшение восстановления",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Уменьшение урона от ближних врагов",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Регенерация",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Увеличение атаки",
	"Увеличение ОЗ",
	"Увеличение урона от босса"]

func update_skill() -> void:
	var count_skills = 1
	for i in range(0, 150, 1):
		var count : int = 0
		if 1 <= i and i <= 3: 
			count = 5
		if 4 <= i and i <= 7: 
			count = 4
		if 8 <= i and i <= 1000: 
			count = 3
		if 11 <= i and i <= 1000: 
			count = 2
		for j in range(count):
			var level_conteiner_buff = level_scroll_conteiner.instantiate()
			var skills_conteiner_buff = scill_scroll_conteiner.instantiate()
			skills_container.add_child(skills_conteiner_buff)
			skills_container.move_child(skills_conteiner_buff, 0)
			level_container.add_child(level_conteiner_buff)
			level_container.move_child(level_conteiner_buff, 0)
			skills_conteiner_buff.for_coins_update_texture_and_discriotion(skills_for_coins[(count_skills - 1) % 25], count_skills)
			skills_conteiner_buff.update_need_level(i)
			if count_skills % 6 != 0 and count_skills != 1:
				skills_conteiner_buff.erase_for_crystal()
			elif count_skills % 6 == 0 or count_skills == 1:
				skills_conteiner_buff.for_crystal_update_texture_and_discriotion(count_skills)
			if i > PlayerIndicatorsManager.LEVEL_PLAYER:
				skills_conteiner_buff.skills_close()
			if j == 0:
				level_conteiner_buff.update_lvl(i)
			else:
				level_conteiner_buff.set_visible_conteiner(false)
			count_skills += 1
	for i in range(2):
		var buff = empty_container.instantiate()
		var buff1 = empty_container.instantiate()
		skills_container.add_child(buff)
		skills_container.move_child(buff, 0)
		level_container.add_child(buff1)
		level_container.move_child(buff1, 0)
	await get_tree().create_timer(0.01).timeout
	level_scroll.scroll_vertical = 1000000
	skill_scroll.scroll_vertical = 1000000

func _process(delta):
	if skill_scroll.scroll_vertical != level_scroll.scroll_vertical and self.visible:
		level_scroll.scroll_vertical = skill_scroll.scroll_vertical

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and self.visible:
		for i in skills_container.get_children():
			if i.has_method("information_close"):
				i.information_close()
