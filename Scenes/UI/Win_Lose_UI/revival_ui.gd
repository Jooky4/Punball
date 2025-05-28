extends Control

@onready var crystals_label = $Player_state/Crystals/Crystals_label
@onready var coins_label = $Player_state/Coins/Coins_label

@onready var player_level_label = $Player_state/Player_level/Player_level_label
@onready var player_level_bar = $Player_state/Player_level/Player_level_bar

@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var label_time = $TextureRect4/Label_time


func update_player_state() -> void:
	update_coins_label()
	update_crystal_label()
	update_level_label_and_bar()


func start_timer() -> void:
	YandexSDK.gameplay_stopped()
	timer.start()
	timer_2.start()


func update_coins_label() -> void:
	coins_label.text = str(PlayerIndicatorsManager.COINS_COUNT)


func update_crystal_label() -> void:
	crystals_label.text = str(PlayerIndicatorsManager.CRYSTALS_COUNT)


func update_level_label_and_bar() -> void:
	player_level_label.text = str(PlayerIndicatorsManager.LEVEL_PLAYER)
	player_level_bar.max_value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_FOR_NEXT_LEVEL
	player_level_bar.value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_PLAYER


func _on_ad_pressed() -> void:
	AudioManager.click()
	YandexSDK.gameplay_stopped()
	YandexSDK.show_rewarded_ad()
	YandexSDK.connect("rewarded_ad", rew_ad_res)
	AudioServer.set_bus_mute(0, true)
	timer.set_paused(true)
	timer_2.set_paused(true)


func _on_crystals_pressed() -> void:
	AudioManager.click()
	if PlayerIndicatorsManager.CRYSTALS_COUNT >= 100:
		timer.stop()
		timer_2.stop()
		PlayerIndicatorsManager.CRYSTALS_COUNT -= 100
		LevelManager.revival(1, true)
		if get_tree().current_scene.has_method("revavil_player"):
			get_tree().get_current_scene().call("revavil_player", true)
		self.visible = false
		YandexSDK.gameplay_started()


func rew_ad_res(result:String) -> void:
	if result == "closed" or result == "error":
		timer.set_paused(false)
		timer_2.set_paused(false)
		AudioServer.set_bus_mute(0, false)
		YandexSDK.gameplay_started()
	elif result == "rewarded":
		timer.stop()
		timer_2.stop()
		LevelManager.revival(0.5, false)
		if get_tree().current_scene.has_method("revavil_player"):
			get_tree().get_current_scene().call("revavil_player", true)
		self.visible = false
	elif result == "opened":
		AudioServer.set_bus_mute(0, true)


func _on_timer_timeout() -> void:
	timer.stop()
	timer_2.stop()
	if LevelManager.boss_on_map:
		PlayerIndicatorsManager.update_count_max_wave(WaveGeneration.count_wave_on_locations[(WaveGeneration.current_location % 10) - 1] - 1)
	else:
		PlayerIndicatorsManager.update_count_max_wave(LevelManager.count_level + 1)
	YandexSDK.gameplay_stopped()
	ChangeScene.to("game_over")


func _on_timer_2_timeout() -> void:
	label_time.text = str(int(label_time.text) - 1)


func _on_texture_button_pressed() -> void:
	timer.stop()
	timer_2.stop()
	if LevelManager.boss_on_map:
		PlayerIndicatorsManager.update_count_max_wave(WaveGeneration.count_wave_on_locations[(WaveGeneration.current_location % 10) - 1] - 1)
	else:
		PlayerIndicatorsManager.update_count_max_wave(LevelManager.count_level + 1)

	ChangeScene.to("game_over")
