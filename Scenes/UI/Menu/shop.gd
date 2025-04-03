extends Control

func _on_coins_1_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("coins_500")

func _on_coins_2_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("coins_2500")

func _on_coins_3_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("coins_7000")

func _on_coins_4_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("coins_16000")

func _on_coins_5_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("coins_35000")

func _on_coins_6_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("coins_80000")


func _on_crystal_1_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("crystal_100")

func _on_crystal_2_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("crystal_500")

func _on_crystal_3_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("crystal_1200")

func _on_crystal_4_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("crystal_2500")

func _on_crystal_5_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("crystal_6000")

func _on_crystal_6_pressed() -> void:
	AudioManager.click()
	YandexSDK.purchase_item("crystal_14000")
