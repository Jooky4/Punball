extends Control

@onready var count_wave = $Wave_container/Count_wave
@onready var player_level_label = $Player_level/Player_level_label
@onready var player_level_bar = $Player_level/Player_level_bar
@onready var level_up_UI = $Level_up_UI

func _ready() -> void:
	if PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS == WaveGeneration.get_count_wave_on_location():
		win()
	elif PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS <= WaveGeneration.get_count_wave_on_location():
		lose()
	level_up_UI.visible = false
	count_wave.text = str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS)
	plus_expiriance_level_player()

func _on_go_to_menu_pressed() -> void:
	AudioManager.click()
	get_tree().change_scene_to_file("res://Scenes/UI/Menu/menu.tscn")

func update_level_label_and_bar() -> void:
	player_level_label.text = str(PlayerIndicatorsManager.LEVEL_PLAYER)
	player_level_bar.max_value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_FOR_NEXT_LEVEL
	player_level_bar.value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_PLAYER

func plus_expiriance_level_player() -> void:
	var current_level = PlayerIndicatorsManager.LEVEL_PLAYER
	var count_exp : int = round(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS * 50 * (WaveGeneration.current_location * 0.1 + 0.9))
	PlayerIndicatorsManager.update_level_player(count_exp)
	var new_level = PlayerIndicatorsManager.LEVEL_PLAYER
	for i in range(new_level - current_level):
		while level_up_UI.visible != false:
			await get_tree().create_timer(0.1).timeout
		level_up_UI.level_up(current_level + i + 1)
	$TextureRect8/MarginContainer/GridContainer/Experiance/Experiance_label.text = "x" + str(count_exp)
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
