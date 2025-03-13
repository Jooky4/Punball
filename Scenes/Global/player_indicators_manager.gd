extends Node

var CRYSTALS_COUNT : int = 100
var COINS_COUNT : int = 0
var LEVEL_PLAYER : int = 1
var LEVEL_EXPERIANCE_PLAYER : int = 0
var LEVEL_EXPERIANCE_FOR_NEXT_LEVEL : int = 500
var CURRENT_LOCATIONS : int = 1
var MAX_WAVE_ON_CURRENT_LOCATIONS : int = 0

func update_player_date_in_game() -> void:
	YandexSDK.connect("data_loaded", player_date_loaded)
	YandexSDK.load_data(["coins", 
						 "crystals", 
						 "level_player",
						 "level_experiance_player", 
						 "level_experiance_for_next_level", 
						 "current_locations", 
						 "max_wave_on_current_locations"])

func get_player_indicators() -> Dictionary:
	return {"coins" : COINS_COUNT, 
			"crystals": CRYSTALS_COUNT,
			"level_player" : LEVEL_PLAYER,
			"level_experiance_player" : LEVEL_EXPERIANCE_PLAYER,
			"level_experiance_for_next_level" : LEVEL_EXPERIANCE_FOR_NEXT_LEVEL,
			"current_locations": CURRENT_LOCATIONS,
			"max_wave_on_current_locations" : MAX_WAVE_ON_CURRENT_LOCATIONS}

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
		CURRENT_LOCATIONS = data["current_locations"]
		MAX_WAVE_ON_CURRENT_LOCATIONS = data["max_wave_on_current_locations"]
	else:
		COINS_COUNT = 300
		CRYSTALS_COUNT = 300
		LEVEL_PLAYER = 1
		LEVEL_EXPERIANCE_PLAYER = 0
		LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = LEVEL_PLAYER * 500
		CURRENT_LOCATIONS = 1
		MAX_WAVE_ON_CURRENT_LOCATIONS = 0

func update_count_max_wave(max_wave) -> void:
	MAX_WAVE_ON_CURRENT_LOCATIONS = max_wave
	update_player_date_on_server()

func update_count_current_location(num_loc : int = 0) -> void:
	if num_loc == 0:
		CURRENT_LOCATIONS += 1
	else:
		CURRENT_LOCATIONS = num_loc
	update_player_date_on_server()

func update_level_player(count_exp) -> void:
	LEVEL_EXPERIANCE_PLAYER += count_exp
	while LEVEL_EXPERIANCE_PLAYER >= LEVEL_EXPERIANCE_FOR_NEXT_LEVEL:
		LEVEL_EXPERIANCE_PLAYER -= LEVEL_EXPERIANCE_FOR_NEXT_LEVEL
		LEVEL_PLAYER += 1
		LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = LEVEL_PLAYER * 500
	update_player_date_on_server()
