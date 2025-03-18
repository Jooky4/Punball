extends Control

@onready var shop_UI = $Shop
@onready var main_menu_UI = $Main_menu
@onready var talents_UI = $Talents
@onready var location_sprite = $Main_menu/Locations/Location_sprite
@onready var location_name_label = $Main_menu/Location_name

@onready var crystals_label = $Player_state/Crystals/Crystals_label
@onready var coins_label = $Player_state/Coins/Coins_label
@onready var max_wave_on_locations_label = $Main_menu/Location_name/Max_wave_on_locations

@onready var player_level_label = $Player_state/Player_level/Player_level_label
@onready var player_level_bar = $Player_state/Player_level/Player_level_bar

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
	Engine.time_scale = 1
	get_tree().paused = false
	YandexSDK.init_game()
	YandexSDK.init_player() 
	YandexSDK.game_ready()
	main_menu_UI.visible = true
	shop_UI.visible = false
	talents_UI.visible = false
	AudioManager.music_start()
	YandexSDK.connect("game_initialized", update_player_indicators)
	YandexSDK.connect("data_loaded", player_date_loaded)
	update_player_indicators()
	#talents_UI.update_skill()

func update_player_indicators() -> void:
	PlayerIndicatorsManager.update_player_date_in_game()
	AudioManager.music_start()

func player_date_loaded(data) -> void:
	update_coins_label()
	update_crystal_label()
	update_level_label_and_bar()
	update_cuurent_location_texture()
	talents_UI.update_skill()

func update_coins_label() -> void:
	coins_label.text = str(PlayerIndicatorsManager.get_player_indicators()["coins"])

func update_crystal_label() -> void:
	crystals_label.text = str(PlayerIndicatorsManager.get_player_indicators()["crystals"])

func update_level_label_and_bar() -> void:
	player_level_label.text = str(PlayerIndicatorsManager.LEVEL_PLAYER)
	player_level_bar.max_value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_FOR_NEXT_LEVEL
	player_level_bar.value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_PLAYER

func update_cuurent_location_texture() -> void:
	current_location = PlayerIndicatorsManager.CURRENT_LOCATIONS
	location_sprite.texture = location[current_location][0]
	location_name_label.text = str(current_location) + ". " + location[current_location][1]
	max_wave_on_locations_label.text = "максимальный уровень " + str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS) + "/" + str(WaveGeneration.count_wave_on_locations[current_location])

func _on_button_pressed() -> void:
	AudioManager.click()
	ChangeScene.black_screen()
	PlayerIndicatorsManager.CURRENT_LOCATIONS = current_location
	WaveGeneration.current_location = PlayerIndicatorsManager.CURRENT_LOCATIONS
	await get_tree().create_timer(0.35).timeout
	LevelManager.restert()
	LevelManager.player_balls = [1, 1, 1, 1]
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
		max_wave_on_locations_label.text = "максимальный уровень " + str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS) + "/" + str(WaveGeneration.count_wave_on_locations[current_location])

func _on_back_location_pressed() -> void:
	AudioManager.click()
	if (current_location - 1) <= location.size() and (current_location - 1) >= 1:
		current_location -= 1
		location_sprite.texture = location[current_location][0]
		location_name_label.text = str(current_location) + ". " + location[current_location][1]
		max_wave_on_locations_label.text = "максимальный уровень " + str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS) + "/" + str(WaveGeneration.count_wave_on_locations[current_location])

func _on_mainmenu_button_pressed() -> void:
	AudioManager.click()
	main_menu_UI.visible = true
	shop_UI.visible = false
	talents_UI.visible = false
