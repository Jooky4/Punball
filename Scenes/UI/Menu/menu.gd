extends Control

@onready var shop_UI = $Shop
@onready var main_menu_UI = $Main_menu
@onready var talents_UI = $Talents

func _ready() -> void:
	main_menu_UI.visible = true
	shop_UI.visible = false
	Engine.max_fps = 10000
	YandexSDK.init_game()
	YandexSDK.game_ready()

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
