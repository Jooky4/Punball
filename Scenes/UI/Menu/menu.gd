extends Control

@onready var shop_UI = $Shop
@onready var main_menu_UI = $Main_menu
@onready var talents_UI = $Talents
@onready var location_sprite = $Main_menu/Locations/Location_sprite
@onready var location_name_label = $Main_menu/Location_name

@onready var crystals_label = $Main_menu/Crystals/Crystals_label
@onready var coins_label = $Main_menu/Coins/Coins_label

var location = {
	1 : [preload("res://Texture/UI/Main_menu/7946966c7e70cd7cae0a844972d0d189.jpg"), "Лихолесье"],
	2 : [preload("res://Texture/UI/Main_menu/187df1185276443abedf225b5eb270b6.jpg"), "Пустыня"],
	3 : [preload("res://Texture/UI/Main_menu/2ca8523a9efd64cae4db7cf73a15a9bd.jpg"), "Замок"]
}
var current_location = 1

func _ready() -> void:
	YandexSDK.init_game()
	YandexSDK.init_player() 
	YandexSDK.game_ready()
	YandexSDK.gameplay_started()
	main_menu_UI.visible = true
	shop_UI.visible = false
	talents_UI.visible = false

func _init() -> void:
	YandexSDK.connect("data_loaded", player_date_loaded)
	PlayerIndicatorsManager.update_player_date_in_game()
	AudioManager.music_start()

func player_date_loaded(data) -> void:
	update_coins_label()
	update_crystal_label()

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
	if (current_location + 1) <= 3 and (current_location + 1) >= 1:
		current_location += 1
		location_sprite.texture = location[current_location][0]
		location_name_label.text = str(current_location) + ". " + location[current_location][1]

func _on_back_location_pressed() -> void:
	AudioManager.click()
	if (current_location - 1) <= 3 and (current_location - 1) >= 1:
		current_location -= 1
		location_sprite.texture = location[current_location][0]
		location_name_label.text = str(current_location) + ". " + location[current_location][1]

func _on_plus_crystal_pressed() -> void:
	AudioManager.click()
	PlayerIndicatorsManager.update_crystal_count(+100)
	update_crystal_label()

func _on_plus_coins_pressed() -> void:
	AudioManager.click()
	PlayerIndicatorsManager.update_coins_count(+100)
	update_coins_label()
