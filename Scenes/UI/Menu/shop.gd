extends Control

@onready var menu = $".."

func _ready() -> void:
	YandexSDK.connect('purchased', _on_purchased)
	YandexSDK.connect('pending_purchases_loaded', _on_pending_purchases)

func _on_purchased(id_buy: String) -> void:
	_process_purchase(id_buy)

func _on_pending_purchases(purchases: Array) -> void:
	for purchase_id in purchases:
		_process_purchase(purchase_id)

func _process_purchase(id_buy) -> void:
	if "coins_500" in id_buy:
		PlayerIndicatorsManager.update_coins_count(500)
	if "coins_2500" in id_buy:
		PlayerIndicatorsManager.update_coins_count(2500)
	if "coins_7000" in id_buy:
		PlayerIndicatorsManager.update_coins_count(7000)
	if "coins_16000" in id_buy:
		PlayerIndicatorsManager.update_coins_count(16000)
	if "coins_35000" in id_buy:
		PlayerIndicatorsManager.update_coins_count(35000)
	if "coins_80000" in id_buy:
		PlayerIndicatorsManager.update_coins_count(80000)

	if "crystal_100" in id_buy:
		PlayerIndicatorsManager.update_crystal_count(100)
	if "crystal_500" in id_buy:
		PlayerIndicatorsManager.update_crystal_count(500)
	if "crystal_1200" in id_buy:
		PlayerIndicatorsManager.update_crystal_count(1200)
	if "crystal_2500" in id_buy:
		PlayerIndicatorsManager.update_crystal_count(2500)
	if "crystal_6000" in id_buy:
		PlayerIndicatorsManager.update_crystal_count(6000)
	if "crystal_14000" in id_buy:
		PlayerIndicatorsManager.update_crystal_count(14000)

	menu.update_coins_label()
	menu.update_crystal_label()


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
