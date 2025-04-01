extends Control

@onready var count_wave = $Wave_container/Count_wave
@onready var player_level_label = $Player_level/Player_level_label
@onready var player_level_bar = $Player_level/Player_level_bar
@onready var level_up_UI = $Level_up_UI

var bitton_AD_not_can_press_texture = preload("res://Texture/UI/Win_Lose_UI/кнопка ADS не активна.png")

var count_coins = 0
var count_exp = 0
var count_rune = 0
var max_wave = 1

func _ready() -> void:
	YandexSDK.gameplay_stopped()
	count_wave.text = str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS)
	max_wave = PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS
	level_up_UI.visible = false
	plus_expiriance_level_player()
	if LevelManager.win_or_lose == "win":
		win()
	elif LevelManager.win_or_lose == "lose":
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
	count_exp = round(max_wave * 50 * (WaveGeneration.current_location * 0.1 + 0.9))
	PlayerIndicatorsManager.update_level_player(round(count_exp))
	var new_level = PlayerIndicatorsManager.LEVEL_PLAYER
	for i in range(new_level - current_level):
		while level_up_UI.visible != false:
			await get_tree().create_timer(0.1).timeout
		level_up_UI.level_up(current_level + i + 1)
	$TextureRect8/MarginContainer/GridContainer/Experiance/Experiance_label.text = "x" + str(round(count_exp))

	count_coins = round(max_wave * 100 * (WaveGeneration.current_location * 0.15 + 0.85))
	if PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL >= 2:
		count_coins = count_coins + (count_coins * 0.05)
	$TextureRect8/MarginContainer/GridContainer/Coins/Coins.text = "x" + str(round(count_coins))
	PlayerIndicatorsManager.update_coins_count(round(count_coins))
	update_level_label_and_bar()

	if PlayerIndicatorsManager.LEVEL_PLAYER >= 5:
		count_rune = round(max_wave * 5)
		PlayerIndicatorsManager.update_rune_count(+count_rune)
		$TextureRect8/MarginContainer/GridContainer/Runes/Runes_label.text = "x" + str(count_rune)
	else:
		$TextureRect8/MarginContainer/GridContainer/Runes/TextureRect.visible = false
		$TextureRect8/MarginContainer/GridContainer/Runes/Runes_label.visible = false

func bonus_for_AD() -> void:
	var current_level = PlayerIndicatorsManager.LEVEL_PLAYER
	PlayerIndicatorsManager.update_level_player(round(count_exp * 0.5))
	$TextureRect8/MarginContainer/GridContainer/Experiance/Experiance_label.text = "x" + str(round(count_exp * 1.5))
	var new_level = PlayerIndicatorsManager.LEVEL_PLAYER
	for i in range(new_level - current_level):
		while level_up_UI.visible != false:
			await get_tree().create_timer(0.1).timeout
		level_up_UI.level_up(current_level + i + 1)
	PlayerIndicatorsManager.update_coins_count(round(count_coins * 0.5))
	$TextureRect8/MarginContainer/GridContainer/Coins/Coins.text = "x" + str(round(count_coins * 1.5))
	update_level_label_and_bar()

	if PlayerIndicatorsManager.LEVEL_PLAYER >= 5:
		PlayerIndicatorsManager.update_rune_count(round(count_rune * 0.5))
		$TextureRect8/MarginContainer/GridContainer/Runes/Runes_label.text = "x" + str(round(count_rune * 1.5))
	else:
		$TextureRect8/MarginContainer/GridContainer/Runes/TextureRect.visible = false
		$TextureRect8/MarginContainer/GridContainer/Runes/Runes_label.visible = false

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
	YandexSDK.gameplay_stopped()
	YandexSDK.show_rewarded_ad()
	YandexSDK.connect("rewarded_ad", rew_ad_res)
	AudioServer.set_bus_mute(0, true)

func rew_ad_res(result:String) -> void:
	if result == "closed" or result == "error":
		AudioServer.set_bus_mute(0, false)
	elif result == "rewarded":
		AudioServer.set_bus_mute(0, false)
		$Button_AD.disabled = true
		$Button_AD.texture_normal = bitton_AD_not_can_press_texture
		bonus_for_AD()
