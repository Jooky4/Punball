extends Control

@onready var count_wave = $Wave_container/Count_wave
@onready var player_level_label = $Player_level/Player_level_label
@onready var player_level_bar = $Player_level/Player_level_bar
@onready var level_up_UI = $Level_up_UI

var count_coins = 0
var count_exp = 0

func _ready() -> void:
	count_wave.text = str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS)
	level_up_UI.visible = false
	plus_expiriance_level_player()
	if PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS == WaveGeneration.get_count_wave_on_location():
		win()
	elif PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS < WaveGeneration.get_count_wave_on_location():
		lose()

func _on_go_to_menu_pressed() -> void:
	AudioManager.click()
	get_tree().change_scene_to_file("res://Scenes/UI/Menu/menu.tscn")

func update_level_label_and_bar() -> void:
	player_level_label.text = str(PlayerIndicatorsManager.LEVEL_PLAYER)
	player_level_bar.max_value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_FOR_NEXT_LEVEL
	player_level_bar.value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_PLAYER

func plus_expiriance_level_player() -> void:
	var current_level = PlayerIndicatorsManager.LEVEL_PLAYER
	count_exp = round(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS * 50 * (WaveGeneration.current_location * 0.1 + 0.9))
	PlayerIndicatorsManager.update_level_player(round(count_exp))
	var new_level = PlayerIndicatorsManager.LEVEL_PLAYER
	for i in range(new_level - current_level):
		while level_up_UI.visible != false:
			await get_tree().create_timer(0.1).timeout
		level_up_UI.level_up(current_level + i + 1)
	$TextureRect8/MarginContainer/GridContainer/Experiance/Experiance_label.text = "x" + str(round(count_exp))

	count_coins = 500
	if PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL >= 2:
		count_coins = count_coins + (count_coins * 0.05)
	$TextureRect8/MarginContainer/GridContainer/Coins/Coins.text = "x" + str(round(count_coins))
	PlayerIndicatorsManager.update_coins_count(round(count_coins))
	update_level_label_and_bar()

func bonus_for_AD() -> void:
	PlayerIndicatorsManager.update_level_player(round(count_exp * 0.5))
	$TextureRect8/MarginContainer/GridContainer/Experiance/Experiance_label.text = "x" + str(round(count_exp * 1.5))
	var new_level = PlayerIndicatorsManager.LEVEL_PLAYER
	var current_level = PlayerIndicatorsManager.LEVEL_PLAYER
	for i in range(new_level - current_level):
		while level_up_UI.visible != false:
			await get_tree().create_timer(0.1).timeout
		level_up_UI.level_up(current_level + i + 1)
	PlayerIndicatorsManager.update_coins_count(round(count_coins * 0.5))
	$TextureRect8/MarginContainer/GridContainer/Coins/Coins.text = "x" + str(round(count_coins * 1.5))
	update_level_label_and_bar()

func win() -> void:
	$Win_Lose_Label/Win.visible = true
	$Win_Lose_Label/TextureRect8.visible = true
	$Win_Lose_Label/Lose.visible = false
	PlayerIndicatorsManager.update_count_max_wave(0)
	PlayerIndicatorsManager.update_count_current_location()

func lose() -> void:
	$Win_Lose_Label/Lose.visible = true
	$Win_Lose_Label/Win.visible = false
	$Win_Lose_Label/TextureRect8.visible = false

func _on_button_ad_pressed() -> void:
	YandexSDK.show_rewarded_ad()
	YandexSDK.connect("rewarded_ad", rew_ad_res)
	AudioServer.set_bus_mute(0, true)

func rew_ad_res(result:String) -> void:
	if result == "closed" or result == "error":
		AudioServer.set_bus_mute(0, false)
	elif result == "rewarded":
		AudioServer.set_bus_mute(0, false)
		$Button_AD.disabled = true
		bonus_for_AD()
