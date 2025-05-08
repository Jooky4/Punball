extends HBoxContainer

@onready var chest_1 = $"Сhest_1"
@onready var chest_2 = $"Сhest_2"
@onready var chest_3 = $"Сhest_3"

@onready var chest_reward_UI = $"../../Chest_reward"
@onready var menu = $"../.."

var count_chest_on_locations = {
	0: 2,
	1: 2,
	2: 3,
	3: 2,
	4: 4,
	5: 2,
	6: 2,
	7: 3,
	8: 2,
	-1: 4
}

func _ready() -> void:
	chest_1.connect("chest_opened", try_open_chest)
	chest_2.connect("chest_opened", try_open_chest)
	chest_3.connect("chest_opened", try_open_chest)

func update_label_chests() -> void:
	if PlayerIndicatorsManager.COUNT_OPEN_CHEST == 0:
		start_chests()
	else:
		var buff1 = calculate_chest_label(PlayerIndicatorsManager.COUNT_OPEN_CHEST + 1)
		chest_1.update_label(buff1)
		chest_1.can_open_or_not(buff1.split("-"))

		var buff2 = calculate_chest_label(PlayerIndicatorsManager.COUNT_OPEN_CHEST + 2)
		chest_2.update_label(buff2)
		chest_2.can_open_or_not(buff2.split("-"))

		var buff3 = calculate_chest_label(PlayerIndicatorsManager.COUNT_OPEN_CHEST + 3)
		chest_3.update_label(buff3)
		chest_3.can_open_or_not(buff3.split("-"))

func calculate_chest_label(num_chest) -> String:
	var final_string = ""
	var location = 1
	var count_chest = 1
	var all_count_chest = 1
	for i in range(0, num_chest+10):
		if count_chest_on_locations[(location % 10) - 1] > count_chest:
			count_chest += 1
			all_count_chest += 1
		elif count_chest_on_locations[(location % 10) - 1] == count_chest:
			count_chest = 1
			location += 1
			all_count_chest += 1

		if all_count_chest == num_chest:
			final_string = str(location) + "-" + str(count_chest * 10)
			return final_string
	return final_string

func start_chests() -> void:
	chest_1.update_label("1-10")
	chest_1.can_open_or_not("1-10".split("-"))
	chest_2.update_label("1-20")
	chest_2.can_open_or_not("1-20".split("-"))
	chest_3.update_label("2-10")
	chest_3.can_open_or_not("2-10".split("-"))

func try_open_chest() -> void:
	if chest_1.can_open:

		AudioManager.click()


		var count_coins = 500 * ((chest_1.location_for_open * 0.15) + 0.85)
		var count_crystal = 0

		if PlayerIndicatorsManager.COUNT_OPEN_CHEST + 1 <= 5:
			YandexMetrika.ym(101336789,'reachGoal','opened_first_chest_for_location')
			count_crystal = 5
		elif 5 < PlayerIndicatorsManager.COUNT_OPEN_CHEST + 1 and PlayerIndicatorsManager.COUNT_OPEN_CHEST + 1 <= 15:
			count_crystal = 10
		elif 15 < PlayerIndicatorsManager.COUNT_OPEN_CHEST + 1 and PlayerIndicatorsManager.COUNT_OPEN_CHEST + 1 <= 35:
			count_crystal = 15
		else:
			count_crystal = 20

		chest_reward_UI.update_reward_and_show_window(count_coins, count_crystal)
		PlayerIndicatorsManager.update_count_open_chest()
		update_label_chests()
		menu.update_coins_label()
		menu.update_crystal_label()
		menu.update_visible_texture_can_update()
