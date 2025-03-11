extends Node

var CRYSTALS_COUNT : int = 0
var COINS_COUNT : int = 0
var LEVEL_PLAYER : int = 1
var LEVEL_EXPERIANCE_PLAYER : int = 0

func update_player_date_in_game() -> void:
	YandexSDK.connect("data_loaded", player_date_loaded)
	YandexSDK.load_data(["coins", "crystals"])

func get_player_indicators() -> Dictionary:
	return {"coins" : COINS_COUNT, 
			"crystals": CRYSTALS_COUNT}

func update_crystal_count(num) -> void:
	CRYSTALS_COUNT += num
	update_player_date_on_server()

func update_coins_count(num) -> void:
	COINS_COUNT += num
	update_player_date_on_server()

func update_player_date_on_server() -> void:
	YandexSDK.save_data(get_player_indicators(), true)

func player_date_loaded(data) -> void:
	COINS_COUNT = data["coins"]
	CRYSTALS_COUNT = data["crystals"]
