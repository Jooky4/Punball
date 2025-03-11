extends Node

var CRYSTALS_COUNT : int = 0
var COINS_COUNT : int = 0
var LEVEL_PLAYER : int = 1
var LEVEL_EXPERIANCE_PLAYER : int = 0

var MAX_WAVE_ON_LOCATIONS = {
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: 0,
	7: 0,
	8: 0,
	9: 0,
	10: 0
}

func update_player_date_in_game() -> void:
	YandexSDK.connect("data_loaded", player_date_loaded)
	YandexSDK.load_data(["coins", "crystals"])

func get_player_indicators() -> Dictionary:
	return {"coins" : COINS_COUNT, 
			"crystals": CRYSTALS_COUNT,
			"max_wave_on_locations": MAX_WAVE_ON_LOCATIONS}

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
	MAX_WAVE_ON_LOCATIONS = data["max_wave_on_locations"]
