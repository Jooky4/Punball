extends Node

var CRYSTALS_COUNT : int = 100
var COINS_COUNT : int = 0
var LEVEL_PLAYER : int = 1
var LEVEL_EXPERIANCE_PLAYER : int = 0
var LEVEL_EXPERIANCE_FOR_NEXT_LEVEL : int = 500

var MAX_WAVE_ON_LOCATIONS_1 = null
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
	YandexSDK.load_data(["coins", "crystals", "level_player", "level_experiance_player", "level_experiance_for_next_level", "max_wave_on_locations_1"])

func get_player_indicators() -> Dictionary:
	return {"coins" : COINS_COUNT, 
			"crystals": CRYSTALS_COUNT,
			"level_player" : LEVEL_PLAYER,
			"level_experiance_player" : LEVEL_EXPERIANCE_PLAYER,
			"level_experiance_for_next_level" : LEVEL_EXPERIANCE_FOR_NEXT_LEVEL,
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
	if data != {}:
		COINS_COUNT = data["coins"]
		CRYSTALS_COUNT = data["crystals"]
		LEVEL_PLAYER = data["level_player"]
		LEVEL_EXPERIANCE_PLAYER = data["level_experiance_player"]
		LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = data["level_experiance_for_next_level"]
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
	else:
		COINS_COUNT = 300
		CRYSTALS_COUNT = 300
		LEVEL_PLAYER = 1
		LEVEL_EXPERIANCE_PLAYER = 0
		LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = LEVEL_PLAYER * 500

func update_count_max_wave(num_location, max_wave) -> void:
	match num_location:
		1:
			if MAX_WAVE_ON_LOCATIONS_1:
				if MAX_WAVE_ON_LOCATIONS_1 < max_wave:
					MAX_WAVE_ON_LOCATIONS_1 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_1 = max_wave
		2:
			if MAX_WAVE_ON_LOCATIONS_2:
				if MAX_WAVE_ON_LOCATIONS_2 < max_wave:
					MAX_WAVE_ON_LOCATIONS_2 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_2 = max_wave
		3:
			if MAX_WAVE_ON_LOCATIONS_3:
				if MAX_WAVE_ON_LOCATIONS_3 < max_wave:
					MAX_WAVE_ON_LOCATIONS_3 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_3 = max_wave
		4:
			if MAX_WAVE_ON_LOCATIONS_4:
				if MAX_WAVE_ON_LOCATIONS_4 < max_wave:
					MAX_WAVE_ON_LOCATIONS_4 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_4 = max_wave
		5:
			if MAX_WAVE_ON_LOCATIONS_5:
				if MAX_WAVE_ON_LOCATIONS_5 < max_wave:
					MAX_WAVE_ON_LOCATIONS_5 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_5 = max_wave
		6:
			if MAX_WAVE_ON_LOCATIONS_6:
				if MAX_WAVE_ON_LOCATIONS_6 < max_wave:
					MAX_WAVE_ON_LOCATIONS_6 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_6 = max_wave
		7:
			if MAX_WAVE_ON_LOCATIONS_7:
				if MAX_WAVE_ON_LOCATIONS_7 < max_wave:
					MAX_WAVE_ON_LOCATIONS_7 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_7 = max_wave
		8:
			if MAX_WAVE_ON_LOCATIONS_8:
				if MAX_WAVE_ON_LOCATIONS_8 < max_wave:
					MAX_WAVE_ON_LOCATIONS_8 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_8 = max_wave
		9:
			if MAX_WAVE_ON_LOCATIONS_9:
				if MAX_WAVE_ON_LOCATIONS_9 < max_wave:
					MAX_WAVE_ON_LOCATIONS_9 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_9 = max_wave
		10:
			if MAX_WAVE_ON_LOCATIONS_10:
				if MAX_WAVE_ON_LOCATIONS_10 < max_wave:
					MAX_WAVE_ON_LOCATIONS_10 = max_wave
			else:
				MAX_WAVE_ON_LOCATIONS_10 = max_wave
	update_player_date_on_server()

func update_level_player(count_exp) -> void:
	LEVEL_EXPERIANCE_PLAYER += count_exp
	while LEVEL_EXPERIANCE_PLAYER >= LEVEL_EXPERIANCE_FOR_NEXT_LEVEL:
		LEVEL_EXPERIANCE_PLAYER -= LEVEL_EXPERIANCE_FOR_NEXT_LEVEL
		LEVEL_PLAYER += 1
		LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = LEVEL_PLAYER * 500
	update_player_date_on_server()
