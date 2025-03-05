extends Control

func _on_ad_pressed() -> void:
	AudioManager.click()
	YandexSDK.show_rewarded_ad()
	AudioServer.set_bus_mute(0, true)
	YandexSDK.connect("interstitial_ad", ad_res)

func _on_crystals_pressed() -> void:
	LevelManager.revival(0.2)
	if get_tree().current_scene.has_method("revavil_player"):
		get_tree().get_current_scene().call("revavil_player")
	self.visible = false

func ad_res(result: String) -> void:
	if result == "rewarded":
		LevelManager.revival(0.2)
		if get_tree().current_scene.has_method("revavil_player"):
			get_tree().get_current_scene().call("revavil_player")
		self.visible = false
		AudioServer.set_bus_mute(0, false)
