extends Node

var CRYSTALS_COUNT : int = 1000
var COINS_COUNT : int = 10000
var LEVEL_PLAYER : int = 1
var LEVEL_EXPERIANCE_PLAYER : int = 0
var LEVEL_EXPERIANCE_FOR_NEXT_LEVEL : int = 500
var CURRENT_LOCATIONS : int = 1
var MAX_WAVE_ON_CURRENT_LOCATIONS : int = 0
var COUNT_BYE_TALANTS_FOR_COINS : int = 0
var COUNT_BYE_TALANTS_FOR_CRYSTAL : int = 0

var FOR_COIS_UP_ATTACK : float = 1.0
var FOR_COIS_UP_OZ : int = 0
var FOR_COIS_DOWN_DAMAGE_CLOSE_ENEMY : int = 0
var FOR_COIS_DOWN_DAMAGE_DISTANT_ENEMY : int = 0
var FOR_COIS_DOWN_DAMAGE_BOSS : int = 0
var FOR_COIS_UP_RESTORE_HILL : int = 0
var FOR_COIS_REGENIRATION : int = 0

var FOR_CRYSTAL_SHANSE_X10_DAMAGE : float = 0
var FOR_CRYSTAL_SHANSE_X100_DAMAGE : float = 0
var FOR_CRYSTAL_UP_DAMAGE_TO_BOSS : float = 0
var FOR_CRYSTAL_UP_DAMAGE : float = 0
var FOR_CRYSTAL_UP_OZ : float = 0
var FOR_CRYSTAL_SHANSE_DOP_BALL : float = 0

func _ready() -> void:
	YandexSDK.connect("data_loaded", player_date_loaded)

func update_player_date_in_game() -> void:
	YandexSDK.load_data(["coins", 
						 "crystals", 
						 "level_player",
						 "level_experiance_player", 
						 "level_experiance_for_next_level", 
						 "current_locations", 
						 "max_wave_on_current_locations",
						 "count_bye_talants_for_coins",
						 "count_bye_talants_for_crystal"])

func get_player_indicators() -> Dictionary:
	return {"coins" : COINS_COUNT, 
			"crystals": CRYSTALS_COUNT,
			"level_player" : LEVEL_PLAYER,
			"level_experiance_player" : LEVEL_EXPERIANCE_PLAYER,
			"level_experiance_for_next_level" : LEVEL_EXPERIANCE_FOR_NEXT_LEVEL,
			"current_locations": CURRENT_LOCATIONS,
			"max_wave_on_current_locations" : MAX_WAVE_ON_CURRENT_LOCATIONS,
			"count_bye_talants_for_coins" : COUNT_BYE_TALANTS_FOR_COINS,
			"count_bye_talants_for_crystal" : COUNT_BYE_TALANTS_FOR_CRYSTAL}

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
		COUNT_BYE_TALANTS_FOR_COINS = data["count_bye_talants_for_coins"]
		COUNT_BYE_TALANTS_FOR_CRYSTAL = data["count_bye_talants_for_crystal"]
	else:
		COINS_COUNT = 10000
		CRYSTALS_COUNT = 1000
		LEVEL_PLAYER = 1
		LEVEL_EXPERIANCE_PLAYER = 0
		LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = LEVEL_PLAYER * 500
		CURRENT_LOCATIONS = 1
		MAX_WAVE_ON_CURRENT_LOCATIONS = 0
		COUNT_BYE_TALANTS_FOR_COINS = 0
		COUNT_BYE_TALANTS_FOR_CRYSTAL = 0

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

func defalt_for_talant() -> void:
	FOR_COIS_UP_ATTACK = 1.0
	FOR_COIS_UP_OZ = 0
	FOR_COIS_DOWN_DAMAGE_CLOSE_ENEMY = 0
	FOR_COIS_DOWN_DAMAGE_DISTANT_ENEMY = 0
	FOR_COIS_DOWN_DAMAGE_BOSS = 0
	FOR_COIS_UP_RESTORE_HILL = 0
	FOR_COIS_REGENIRATION = 0

	FOR_CRYSTAL_SHANSE_X10_DAMAGE = 0
	FOR_CRYSTAL_SHANSE_X100_DAMAGE = 0
	FOR_CRYSTAL_UP_DAMAGE_TO_BOSS = 0
	FOR_CRYSTAL_UP_DAMAGE = 0
	FOR_CRYSTAL_UP_OZ = 0
	FOR_CRYSTAL_SHANSE_DOP_BALL = 0

func buy_crystal_talant() -> void:
	COUNT_BYE_TALANTS_FOR_CRYSTAL += 1
	update_player_date_on_server()

func buy_coins_talant() -> void:
	COUNT_BYE_TALANTS_FOR_COINS += 1
	update_player_date_on_server()
