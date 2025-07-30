extends Control
@onready var coins_grid_container: GridContainer = $ScrollContainer/VBoxContainer/TextureRect2/PanelContainer/GridContainer
@onready var crystal_grid_container: GridContainer = $ScrollContainer/VBoxContainer/TextureRect4/PanelContainer/GridContainer


var shop_items: Dictionary = {
	"coins_500": "Coins_1",
	"coins_2500": "Coins_2",
	"coins_7000": "Coins_3",
	"coins_16000": "Coins_4",
	"coins_35000": "Coins_5",
	"coins_80000": "Coins_6",
	"crystal_100": "Crystal_1",
	"crystal_500": "Crystal_2",
	"crystal_1200": "Crystal_3",
	"crystal_2500": "Crystal_4",
	"crystal_6000": "Crystal_5",
	"crystal_14000": "Crystal_6",
}

func update_price(catalog_items) -> void:
	var avail_price: Array

	for i in catalog_items:
		var shop_item
		var _id = i["tag"]
		var _item = shop_items[_id]
		avail_price.push_back(_id)

		if "coins" in _id:
			shop_item = coins_grid_container.get_node(_item)
		elif "crystal" in _id:
			shop_item = crystal_grid_container.get_node(_item)

		# для яндекса
		if false and shop_item:
			# неразрывный пробел - код символа 160
			var unbreakable_space = " "
			var val = i.price.split(unbreakable_space)

			if val.size() == 1:
				# Обычный пробел
				var common_space = " "
				val = i.price.split(common_space)

			shop_item.price = val[0]
			shop_item.currency = val[1]

		#prints("Товар: ", i["tag"], "price", i["price"], "currency", i["currency"], "currencySymbol", i["currency_symbol"])
		shop_item.price = i["price"]
		#shop_item.currency = i["currency"]
		shop_item.currency = i["currency_symbol"]

	# Прячем недоступные товары
	for i in shop_items.keys():
		var _item = shop_items[i]
		if i not in avail_price:
			if "coins" in i:
				coins_grid_container.get_node(_item).hide()
			elif "crystal" in i:
				crystal_grid_container.get_node(_item).hide()


func _on_coins_1_pressed() -> void:
	AudioManager.click()
	_purchase_item("coins_500")

func _on_coins_2_pressed() -> void:
	AudioManager.click()
	_purchase_item("coins_2500")

func _on_coins_3_pressed() -> void:
	AudioManager.click()
	_purchase_item("coins_7000")

func _on_coins_4_pressed() -> void:
	AudioManager.click()
	_purchase_item("coins_16000")

func _on_coins_5_pressed() -> void:
	AudioManager.click()
	_purchase_item("coins_35000")

func _on_coins_6_pressed() -> void:
	AudioManager.click()
	_purchase_item("coins_80000")

func _on_crystal_1_pressed() -> void:
	AudioManager.click()
	_purchase_item("crystal_100")

func _on_crystal_2_pressed() -> void:
	AudioManager.click()
	_purchase_item("crystal_500")

func _on_crystal_3_pressed() -> void:
	AudioManager.click()
	_purchase_item("crystal_1200")

func _on_crystal_4_pressed() -> void:
	AudioManager.click()
	_purchase_item("crystal_2500")

func _on_crystal_5_pressed() -> void:
	AudioManager.click()
	_purchase_item("crystal_6000")

func _on_crystal_6_pressed() -> void:
	AudioManager.click()
	_purchase_item("crystal_14000")


func _purchase_item(tag: String) -> void:
	#YandexSDK.purchase_item(tag)
	prints("purchase item", { "tag": tag })
	GP.Payments.purchase(null, tag)
