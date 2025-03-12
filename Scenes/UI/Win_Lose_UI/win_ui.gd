extends Control

@onready var count_wave = $Wave_container/Count_wave

func _ready() -> void:
	count_wave.text = str(WaveGeneration.get_count_wave_on_location())
	PlayerIndicatorsManager.update_count_max_wave(WaveGeneration.current_location, WaveGeneration.get_count_wave_on_location())

func _on_go_to_menu_pressed() -> void:
	AudioManager.click()
	get_tree().change_scene_to_file("res://Scenes/UI/Menu/menu.tscn")
