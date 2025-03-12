extends Control

@onready var count_wave = $Wave_container/Count_wave
@onready var player_level_label = $Player_level/Player_level_label
@onready var player_level_bar = $Player_level/Player_level_bar
@onready var level_up_UI = $Level_up_UI

func _ready() -> void:
	level_up_UI.visible = false
	count_wave.text = str(WaveGeneration.get_count_wave_on_location())
	PlayerIndicatorsManager.update_count_max_wave(WaveGeneration.current_location, WaveGeneration.get_count_wave_on_location())
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
	var count_exp : int = round(WaveGeneration.get_count_wave_on_location() * 50 * (WaveGeneration.current_location * 0.5 + 0.5))
	PlayerIndicatorsManager.update_level_player(count_exp)
	var new_level = PlayerIndicatorsManager.LEVEL_PLAYER
	for i in range(new_level - current_level):
		while level_up_UI.visible != false:
			await get_tree().create_timer(0.1).timeout
		level_up_UI.level_up(current_level + i + 1)
	update_level_label_and_bar()
