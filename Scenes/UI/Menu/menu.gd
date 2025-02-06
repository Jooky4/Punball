extends Control

func _ready() -> void:
	YandexSDK.init_game()
	YandexSDK.game_ready()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/first_level.tscn")

func _on_button_2_pressed() -> void:
	YandexSDK.show_interstitial_ad()

func _on_button_3_pressed() -> void:
	YandexSDK.show_rewarded_ad()

func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/2.tscn")
