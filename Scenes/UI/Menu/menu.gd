extends Control

@onready var shop_UI = $Shop
@onready var main_menu_UI = $Main_menu
@onready var talents_UI = $Talents
@onready var location_sprite = $Main_menu/Locations/Location_sprite
@onready var location_name_label = $Main_menu/Location_name

@onready var crystals_label = $Main_menu/Crystals/Crystals_label
@onready var coins_label = $Main_menu/Coins/Coins_label
@onready var max_wave_on_locations_label = $Main_menu/Location_name/Max_wave_on_locations

@onready var play_button = $Main_menu/PLay_button
var button_play_disabled = preload("res://Texture/UI/Main_menu/кнопка Играть не активна.png")
var button_play_can_press = preload("res://Texture/UI/Main_menu/кнопка Играть.png")

var location = {
	1 : [preload("res://Texture/UI/Main_menu/7946966c7e70cd7cae0a844972d0d189.jpg"), "Лихолесье"],
	2 : [preload("res://Texture/UI/Main_menu/187df1185276443abedf225b5eb270b6.jpg"), "Пустыня"],
	3 : [preload("res://Texture/UI/Main_menu/2ca8523a9efd64cae4db7cf73a15a9bd.jpg"), "Замок"],
	4 : [preload("res://Texture/UI/Main_menu/7946966c7e70cd7cae0a844972d0d189.jpg"), "Туманграф"],
	5 : [preload("res://Texture/UI/Main_menu/187df1185276443abedf225b5eb270b6.jpg"), "Эфирион"],
	6 : [preload("res://Texture/UI/Main_menu/2ca8523a9efd64cae4db7cf73a15a9bd.jpg"), "Ржавник"],
	7 : [preload("res://Texture/UI/Main_menu/7946966c7e70cd7cae0a844972d0d189.jpg"), "Лунарис"],
	8 : [preload("res://Texture/UI/Main_menu/187df1185276443abedf225b5eb270b6.jpg"), "Шептоль"],
	9 : [preload("res://Texture/UI/Main_menu/2ca8523a9efd64cae4db7cf73a15a9bd.jpg"), "Пламеград"],
	10 : [preload("res://Texture/UI/Main_menu/7946966c7e70cd7cae0a844972d0d189.jpg"), "Безднария"]
}
var current_location = 1

func _ready() -> void:
	YandexSDK.init_game()
	YandexSDK.init_player() 
	YandexSDK.game_ready()
	main_menu_UI.visible = true
	shop_UI.visible = false
	talents_UI.visible = false
	AudioManager.music_start()
	YandexSDK.connect("game_initialized", update_player_indicators)
	update_player_indicators()

func update_player_indicators() -> void:
	YandexSDK.connect("data_loaded", player_date_loaded)
	PlayerIndicatorsManager.update_player_date_in_game()
	AudioManager.music_start()

func player_date_loaded(data) -> void:
	update_coins_label()
	update_crystal_label()
	if get_count_max_wave(current_location) != null:
		max_wave_on_locations_label.text = "максимальный уровень " + str(get_count_max_wave(current_location)) + "/" + str(WaveGeneration.count_wave_on_locations[current_location])
	else:
		max_wave_on_locations_label.text = "максимальный уровень 0/" + str(WaveGeneration.count_wave_on_locations[current_location])

func update_coins_label() -> void:
	coins_label.text = str(PlayerIndicatorsManager.get_player_indicators()["coins"])

func update_crystal_label() -> void:
	crystals_label.text = str(PlayerIndicatorsManager.get_player_indicators()["crystals"])

func _on_button_pressed() -> void:
	AudioManager.click()
	ChangeScene.black_screen()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/first_level.tscn")

func _on_shop_button_pressed() -> void:
	AudioManager.click()
	shop_UI.visible = true
	main_menu_UI.visible = false
	talents_UI.visible = false

func _on_talesnts_button_pressed() -> void:
	AudioManager.click()
	talents_UI.visible = true
	main_menu_UI.visible = false
	shop_UI.visible = false

func _on_next_location_pressed() -> void:
	AudioManager.click()
	if (current_location + 1) <= location.size() and (current_location + 1) >= 1:
		current_location += 1
		location_sprite.texture = location[current_location][0]
		location_name_label.text = str(current_location) + ". " + location[current_location][1]
	if get_count_max_wave(current_location) != null:
		max_wave_on_locations_label.text = "максимальный уровень " + str(get_count_max_wave(current_location)) + "/" + str(WaveGeneration.count_wave_on_locations[current_location])
	else:
		max_wave_on_locations_label.text = "максимальный уровень 0/" + str(WaveGeneration.count_wave_on_locations[current_location])
	if current_location == 1:
		play_button.disabled = false
		play_button.texture_normal = button_play_can_press
	else:
		play_button.disabled = true
		play_button.texture_normal = button_play_disabled

func _on_back_location_pressed() -> void:
	AudioManager.click()
	if (current_location - 1) <= location.size() and (current_location - 1) >= 1:
		current_location -= 1
		location_sprite.texture = location[current_location][0]
		location_name_label.text = str(current_location) + ". " + location[current_location][1]
	if get_count_max_wave(current_location) != null:
		max_wave_on_locations_label.text = "максимальный уровень " + str(get_count_max_wave(current_location)) + "/" + str(WaveGeneration.count_wave_on_locations[current_location])
	else:
		max_wave_on_locations_label.text = "максимальный уровень 0/" + str(WaveGeneration.count_wave_on_locations[current_location])
	if current_location == 1:
		play_button.disabled = false
		play_button.texture_normal = button_play_can_press
	else:
		play_button.disabled = true
		play_button.texture_normal = button_play_disabled

func _on_plus_crystal_pressed() -> void:
	AudioManager.click()
	PlayerIndicatorsManager.update_crystal_count(+100)
	update_crystal_label()

func _on_plus_coins_pressed() -> void:
	AudioManager.click()
	PlayerIndicatorsManager.update_coins_count(+100)
	update_coins_label()

func get_count_max_wave(num_location):
	match num_location:
		1:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_1
		2:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_2
		3:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_3
		4:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_4
		5:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_5
		6:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_6
		7:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_7
		8:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_8
		9:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_9
		10:
			return PlayerIndicatorsManager.MAX_WAVE_ON_LOCATIONS_10
