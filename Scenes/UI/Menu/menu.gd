extends Control

@onready var shop_UI = $Shop
@onready var main_menu_UI = $Main_menu
@onready var talents_UI = $Talents
@onready var location_sprite = $Main_menu/Locations/Location_sprite
@onready var location_name_label = $Main_menu/Location_name
var location = {
	1 : [preload("res://Texture/UI/Main_menu/7946966c7e70cd7cae0a844972d0d189.jpg"), "Лихолесье"],
	2 : [preload("res://Texture/UI/Main_menu/187df1185276443abedf225b5eb270b6.jpg"), "Пустыня"],
	3 : [preload("res://Texture/UI/Main_menu/2ca8523a9efd64cae4db7cf73a15a9bd.jpg"), "Замок"]
}
var current_location = 1

func _ready() -> void:
	YandexSDK.init_game()
	YandexSDK.game_ready()
	Engine.max_fps = 10000
	main_menu_UI.visible = true
	shop_UI.visible = false
	AudioManager.musiic_start()

func _on_button_pressed() -> void:
	AudioManager.click()
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
