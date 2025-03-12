extends Node

var CRYSTALS_COUNT : int = 0
var COINS_COUNT : int = 0
var LEVEL_PLAYER : int = 1
var LEVEL_EXPERIANCE_PLAYER : int = 0
var MAX_WAVE_ON_LOCATIONS_1 = 0
var MAX_WAVE_ON_LOCATIONS_2 = 0
var MAX_WAVE_ON_LOCATIONS_3 = 0
var MAX_WAVE_ON_LOCATIONS_4 = 0
var MAX_WAVE_ON_LOCATIONS_5 = 0
var MAX_WAVE_ON_LOCATIONS_6 = 0
var MAX_WAVE_ON_LOCATIONS_7 = 0
var MAX_WAVE_ON_LOCATIONS_8 = 0
var MAX_WAVE_ON_LOCATIONS_9 = 0
var MAX_WAVE_ON_LOCATIONS_10 = 0

func update_player_date_in_game() -> void:
	YandexSDK.connect("data_loaded", player_date_loaded)
	YandexSDK.load_data(["coins", "crystals", "max_wave_on_locations_1"])

func get_player_indicators() -> Dictionary:
	return {"coins" : COINS_COUNT, 
			"crystals": CRYSTALS_COUNT,
			"max_wave_on_locations_1" : MAX_WAVE_ON_LOCATIONS_1,
			"max_wave_on_locations_2" : MAX_WAVE_ON_LOCATIONS_2,
			"max_wave_on_locations_3" : MAX_WAVE_ON_LOCATIONS_3,
			"max_wave_on_locations_4" : MAX_WAVE_ON_LOCATIONS_4,
			"max_wave_on_locations_5" : MAX_WAVE_ON_LOCATIONS_5,
			"max_wave_on_locations_6" : MAX_WAVE_ON_LOCATIONS_6,
			"max_wave_on_locations_7" : MAX_WAVE_ON_LOCATIONS_7,
			"max_wave_on_locations_8" : MAX_WAVE_ON_LOCATIONS_8,
			"max_wave_on_locations_9" : MAX_WAVE_ON_LOCATIONS_9,
			"max_wave_on_locations_10" :  MAX_WAVE_ON_LOCATIONS_10}

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
	MAX_WAVE_ON_LOCATIONS_1 = data["max_wave_on_locations_1"]
	MAX_WAVE_ON_LOCATIONS_2 = data["max_wave_on_locations_2"]
	MAX_WAVE_ON_LOCATIONS_3 = data["max_wave_on_locations_3"]
	MAX_WAVE_ON_LOCATIONS_4 = data["max_wave_on_locations_4"]
	MAX_WAVE_ON_LOCATIONS_5 = data["max_wave_on_locations_5"]
	MAX_WAVE_ON_LOCATIONS_6 = data["max_wave_on_locations_6"]
	MAX_WAVE_ON_LOCATIONS_7 = data["max_wave_on_locations_7"]
	MAX_WAVE_ON_LOCATIONS_8 = data["max_wave_on_locations_8"]
	MAX_WAVE_ON_LOCATIONS_9 = data["max_wave_on_locations_9"]
	MAX_WAVE_ON_LOCATIONS_10 = data["max_wave_on_locations_10"]

func update_count_max_wave(num_location, max_wave) -> void:
	match num_location:
		1:
			if MAX_WAVE_ON_LOCATIONS_1 < max_wave or MAX_WAVE_ON_LOCATIONS_1 == null:
				MAX_WAVE_ON_LOCATIONS_1 = max_wave
		2:
			if MAX_WAVE_ON_LOCATIONS_2 < max_wave or MAX_WAVE_ON_LOCATIONS_2 == null:
				MAX_WAVE_ON_LOCATIONS_2 = max_wave
		3:
			if MAX_WAVE_ON_LOCATIONS_3 < max_wave or MAX_WAVE_ON_LOCATIONS_3 == null:
				MAX_WAVE_ON_LOCATIONS_3 = max_wave
		4:
			if MAX_WAVE_ON_LOCATIONS_4 < max_wave or MAX_WAVE_ON_LOCATIONS_4 == null:
				MAX_WAVE_ON_LOCATIONS_4 = max_wave
		5:
			if MAX_WAVE_ON_LOCATIONS_5 < max_wave or MAX_WAVE_ON_LOCATIONS_5 == null:
				MAX_WAVE_ON_LOCATIONS_5 = max_wave
		6:
			if MAX_WAVE_ON_LOCATIONS_6 < max_wave or MAX_WAVE_ON_LOCATIONS_6 == null:
				MAX_WAVE_ON_LOCATIONS_6 = max_wave
		7:
			if MAX_WAVE_ON_LOCATIONS_7 < max_wave or MAX_WAVE_ON_LOCATIONS_7 == null:
				MAX_WAVE_ON_LOCATIONS_7 = max_wave
		8:
			if MAX_WAVE_ON_LOCATIONS_8 < max_wave or MAX_WAVE_ON_LOCATIONS_8 == null:
				MAX_WAVE_ON_LOCATIONS_8 = max_wave
		9:
			if MAX_WAVE_ON_LOCATIONS_9 < max_wave or MAX_WAVE_ON_LOCATIONS_9 == null:
				MAX_WAVE_ON_LOCATIONS_9 = max_wave
		10:
			if MAX_WAVE_ON_LOCATIONS_10 < max_wave or MAX_WAVE_ON_LOCATIONS_10 == null:
				MAX_WAVE_ON_LOCATIONS_10 = max_wave
