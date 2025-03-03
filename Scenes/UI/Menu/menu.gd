extends Control

func _ready() -> void:
	Engine.max_fps = 10000
	YandexSDK.init_game()
	YandexSDK.game_ready()

func _on_button_pressed() -> void:
	AudioManager.click()
	get_tree().change_scene_to_file("res://Scenes/Levels/first_level.tscn")

func _on_button_2_pressed() -> void:
	AudioManager.click()
	YandexSDK.show_interstitial_ad()

func _on_button_3_pressed() -> void:
	AudioManager.click()
	YandexSDK.show_rewarded_ad()
