extends Control

@onready var empty_container = preload("res://Scenes/UI/Talents_UI/buff.tscn")

@onready var level_scroll_conteiner = preload("res://Scenes/UI/Talents_UI/level_scroll_conteiner.tscn")
@onready var scill_scroll_conteiner = preload("res://Scenes/UI/Talents_UI/scill_scroll_conteiner.tscn")

@onready var level_scroll = $Lvl_ScrollContainer
@onready var skill_scroll = $Scill_ScrollContainer

@onready var skills_container = $Scill_ScrollContainer/Skills_container
@onready var level_container = $Lvl_ScrollContainer/Level_container

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

var skills_for_crystall = [
	"Атака +5%",
	"1% нанести в 10 раз больше урона",
	"Урон по боссу на 10% больше",
	"5% шанс при взятии “+1 шар” получить 2 шара",
	"0,1% нанести в 100 раз больше урона",
	"ОЗ +5%"]

var first_time_open = true

func update_skill() -> void:
	var count_skills = 1
	for i in range(1, 151, 1):
		for j in range(3):
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
	var buff = empty_container.instantiate()
	var buff1 = empty_container.instantiate()
	skills_container.add_child(buff)
	skills_container.move_child(buff, 0)
	level_container.add_child(buff1)
	level_container.move_child(buff1, 0)

	update_player_indicator_talant_for_coins()

func _process(delta):
	if self.visible and first_time_open == false:
		if skill_scroll.scroll_vertical != level_scroll.scroll_vertical:
			level_scroll.scroll_vertical = skill_scroll.scroll_vertical

func _input(event: InputEvent) -> void:
	if self.visible:
		if event is InputEventMouseButton:
			for i in skills_container.get_children():
				if i.has_method("information_close"):
					i.information_close()

func update_scroll() -> void:
	if first_time_open:
		await get_tree().create_timer(0.05).timeout
	level_scroll.scroll_vertical = 100000
	skill_scroll.scroll_vertical = 100000
	level_scroll.scroll_vertical = level_scroll.scroll_vertical - (612 * (PlayerIndicatorsManager.LEVEL_PLAYER - 1))
	skill_scroll.scroll_vertical = skill_scroll.scroll_vertical - (612 * (PlayerIndicatorsManager.LEVEL_PLAYER - 1))
	first_time_open = false

func update_player_indicator_talant_for_coins() -> void:
	PlayerIndicatorsManager.defalt_for_talant()
	var count_for_attack : int = 1
	var count_for_OZ : int = 1
	var count_down_damage_distans_enemy : int = 1
	var count_down_damage_close_enemy : int = 1
	var count_down_boss_damage : int = 1
	var count_up_restore_OZ : int = 1
	var count_regeniration : int = 1
	for i in range(PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_COINS):
		match skills_for_coins[i % 25]:
			"Увеличение атаки":
				PlayerIndicatorsManager.FOR_COIS_UP_ATTACK += 0.2 * count_for_attack
				count_for_attack += 1
			"Увеличение ОЗ":
				PlayerIndicatorsManager.FOR_COIS_UP_OZ += 50 * count_for_OZ
				count_for_OZ += 1
			"Уменьшение урона от дальних врагов":
				PlayerIndicatorsManager.FOR_COIS_DOWN_DAMAGE_DISTANT_ENEMY += 20 * count_down_damage_distans_enemy
				count_down_damage_distans_enemy += 1
			"Уменьшение урона от ближних врагов":
				PlayerIndicatorsManager.FOR_COIS_DOWN_DAMAGE_CLOSE_ENEMY += 100 * count_down_damage_close_enemy
				count_down_damage_close_enemy += 1
			"Улучшение восстановления":
				PlayerIndicatorsManager.FOR_COIS_UP_RESTORE_HILL += 50 * count_up_restore_OZ
				count_up_restore_OZ += 1
			"Регенерация":
				PlayerIndicatorsManager.FOR_COIS_REGENIRATION += 20 * count_regeniration
				count_regeniration += 1
			"Увеличение урона от босса":
				PlayerIndicatorsManager.FOR_COIS_DOWN_DAMAGE_BOSS += 20 * count_down_boss_damage
				count_down_boss_damage += 1
	update_player_indicator_talant_for_crystal()

func update_player_indicator_talant_for_crystal() -> void:
	var count_shanse_x10_damage : int = 1
	var count_shanse_x100_damage : int = 1
	var count_up_damage_to_boss : int = 1
	var count_up_damage : int = 1
	var count_up_OZ : int = 1
	var count_shanse_dop_ball : int = 1 
	for i in range(PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL):
		if i != 0 and i != 1:
			match skills_for_crystall[(i - 2) % 6]:
				"Атака +5%":
					PlayerIndicatorsManager.FOR_CRYSTAL_UP_DAMAGE += 0.05 * count_up_damage
					count_up_damage += 1
				"1% нанести в 10 раз больше урона":
					PlayerIndicatorsManager.FOR_CRYSTAL_SHANSE_X10_DAMAGE += 0.01 * count_shanse_x10_damage
					count_shanse_x10_damage += 1
				"Урон по боссу на 10% больше":
					PlayerIndicatorsManager.FOR_CRYSTAL_UP_DAMAGE_TO_BOSS += 0.1 * count_up_damage_to_boss
					count_up_damage_to_boss += 1
				"5% шанс при взятии “+1 шар” получить 2 шара":
					PlayerIndicatorsManager.FOR_CRYSTAL_SHANSE_DOP_BALL += 0.05 * count_shanse_dop_ball
					count_shanse_dop_ball += 1
				"0,1% нанести в 100 раз больше урона":
					PlayerIndicatorsManager.FOR_CRYSTAL_SHANSE_X100_DAMAGE += 0.001 * count_shanse_x100_damage
					count_shanse_x100_damage += 1
				"ОЗ +5%":
					PlayerIndicatorsManager.FOR_CRYSTAL_UP_OZ += 0.05 * count_up_OZ
					count_up_OZ += 1
