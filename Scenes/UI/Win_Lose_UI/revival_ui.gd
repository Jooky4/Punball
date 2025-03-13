extends Control

func update_count_cristal() -> void:
	$Label.text = str(PlayerIndicatorsManager.CRYSTALS_COUNT)

func _on_ad_pressed() -> void:
	AudioManager.click()
	YandexSDK.show_rewarded_ad()
	YandexSDK.connect("rewarded_ad", rew_ad_res)
	AudioServer.set_bus_mute(0, true)

func _on_crystals_pressed() -> void:
	if PlayerIndicatorsManager.CRYSTALS_COUNT >= 100:
		AudioManager.click()
		PlayerIndicatorsManager.CRYSTALS_COUNT -= 100
		LevelManager.revival(0.2)
		if get_tree().current_scene.has_method("revavil_player"):
			get_tree().get_current_scene().call("revavil_player")
		self.visible = false

func rew_ad_res(result:String) -> void:
	if result == "closed" or result == "error":
		AudioServer.set_bus_mute(0, false)
	elif result == "rewarded":
		AudioServer.set_bus_mute(0, false)
		LevelManager.revival(0.2)
		if get_tree().current_scene.has_method("revavil_player"):
			get_tree().get_current_scene().call("revavil_player")
		self.visible = false
