extends Control

func update_price(catalog_items) -> void:
	for i in catalog_items:
		match i["id"]:
			"coins_500":
				$ScrollContainer/VBoxContainer/TextureRect2/GridContainer/Coins_1/Label.text = i.price
			"coins_2500":
				$ScrollContainer/VBoxContainer/TextureRect2/GridContainer/Coins_2/Label.text = i.price
			"coins_7000":
				$ScrollContainer/VBoxContainer/TextureRect2/GridContainer/Coins_3/Label.text = i.price
			"coins_16000":
				$ScrollContainer/VBoxContainer/TextureRect2/GridContainer/Coins_4/Label.text = i.price
			"coins_35000":
				$ScrollContainer/VBoxContainer/TextureRect2/GridContainer/Coins_5/Label.text = i.price
			"coins_80000":
				$ScrollContainer/VBoxContainer/TextureRect2/GridContainer/Coins_6/Label.text = i.price

			"crystal_100":
				$ScrollContainer/VBoxContainer/TextureRect4/GridContainer/Crystal_1/Label.text = i.price
			"crystal_500":
				$ScrollContainer/VBoxContainer/TextureRect4/GridContainer/Crystal_2/Label.text = i.price
			"crystal_1200":
				$ScrollContainer/VBoxContainer/TextureRect4/GridContainer/Crystal_3/Label.text = i.price
			"crystal_2500":
				$ScrollContainer/VBoxContainer/TextureRect4/GridContainer/Crystal_4/Label.text = i.price
			"crystal_6000":
				$ScrollContainer/VBoxContainer/TextureRect4/GridContainer/Crystal_5/Label.text = i.price
			"crystal_14000":
				$ScrollContainer/VBoxContainer/TextureRect4/GridContainer/Crystal_6/Label.text = i.price

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
