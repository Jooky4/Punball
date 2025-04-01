extends Control

@onready var menu = $".."

func _ready() -> void:
	YandexSDK.connect('purchased', byu)

func byu(id_buy) -> void:
	if id_buy == "coins_500":
		PlayerIndicatorsManager.update_coins_count(500)
	elif id_buy == "coins_2500":
		PlayerIndicatorsManager.update_coins_count(2500)
	elif id_buy == "coins_7000":
		PlayerIndicatorsManager.update_coins_count(7000)
	elif id_buy == "coins_16000":
		PlayerIndicatorsManager.update_coins_count(16000)
	elif id_buy == "coins_35000":
		PlayerIndicatorsManager.update_coins_count(35000)
	elif id_buy == "coins_80000":
		PlayerIndicatorsManager.update_coins_count(80000)

	if id_buy == "crystal_100":
		PlayerIndicatorsManager.update_crystal_count(100)
	elif id_buy == "crystal_500":
		PlayerIndicatorsManager.update_crystal_count(500)
	elif id_buy == "crystal_1200":
		PlayerIndicatorsManager.update_crystal_count(1200)
	elif id_buy == "crystal_2500":
		PlayerIndicatorsManager.update_crystal_count(2500)
	elif id_buy == "crystal_6000":
		PlayerIndicatorsManager.update_crystal_count(6000)
	elif id_buy == "crystal_14000":
		PlayerIndicatorsManager.update_crystal_count(14000)

	menu.update_coins_label()
	menu.update_crystal_label()


func _on_coins_1_pressed(extra_arg_0: int) -> void:
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
