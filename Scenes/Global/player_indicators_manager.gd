extends Node

var CRYSTALS_COUNT : int = 100
var COINS_COUNT : int = 500
var COUNT_RUNE : int = 0
var LEVEL_PLAYER : int = 1
var LEVEL_EXPERIANCE_PLAYER : int = 0
var LEVEL_EXPERIANCE_FOR_NEXT_LEVEL : int = 1000
var CURRENT_LOCATIONS : int = 1
var MAX_WAVE_ON_CURRENT_LOCATIONS : int = 0
var COUNT_BYE_TALANTS_FOR_COINS : int = 0
var COUNT_BYE_TALANTS_FOR_CRYSTAL : int = 0
var COUNT_OPEN_CHEST : int = 0

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

var SHOW_AD_FIRST_TIME : bool = false

var ENEMY_1_FIRST_TIME : int = 0
var ENEMY_2_FIRST_TIME : int = 0
var ENEMY_3_FIRST_TIME : int = 0
var ENEMY_5_FIRST_TIME : int = 0
var ENEMY_6_FIRST_TIME : int = 0
var ENEMY_8_FIRST_TIME : int = 0
var ENEMY_9_FIRST_TIME : int = 0
var ENEMY_10_FIRST_TIME : int = 0
var ENEMY_12_FIRST_TIME : int = 0
var ENEMY_13_FIRST_TIME : int = 0
var ENEMY_14_FIRST_TIME : int = 0

var CURRENT_CHARACTER : int = 1

var CHARACTER_1_LVL : int = 1
var CHARACTER_2_LVL : int = 0
var CHARACTER_3_LVL : int = 0

var CHARACTER_UP_ATTACK : float = 1.0
var CHARACTER_3_UP_ATTACK_FROM_OZ : float = 1.0

func _ready() -> void:
	YandexSDK.connect("data_loaded", player_date_loaded)

func update_player_date_in_game() -> void:
	YandexSDK.load_data(["coins", 
						 "crystals", 
						 "rune",
						 "level_player",
						 "level_experiance_player", 
						 "level_experiance_for_next_level", 
						 "current_locations", 
						 "max_wave_on_current_locations",
						 "count_bye_talants_for_coins",
						 "count_bye_talants_for_crystal",
						 "count_open_chest",
						 "enemy_1_first_time",
						 "enemy_2_first_time",
						 "enemy_3_first_time",
						 "enemy_5_first_time",
						 "enemy_6_first_time",
						 "enemy_8_first_time",
						 "enemy_9_first_time",
						 "enemy_10_first_time",
						 "enemy_12_first_time",
						 "enemy_13_first_time",
						 "enemy_14_first_time",
						 "current_character",
						 "character_1_lvl",
						 "character_2_lvl",
						 "character_3_lvl"])

func get_player_indicators() -> Dictionary:
	return {"coins" : COINS_COUNT, 
			"crystals": CRYSTALS_COUNT,
			"rune" : COUNT_RUNE,
			"level_player" : LEVEL_PLAYER,
			"level_experiance_player" : LEVEL_EXPERIANCE_PLAYER,
			"level_experiance_for_next_level" : LEVEL_EXPERIANCE_FOR_NEXT_LEVEL,
			"current_locations": CURRENT_LOCATIONS,
			"max_wave_on_current_locations" : MAX_WAVE_ON_CURRENT_LOCATIONS,
			"count_bye_talants_for_coins" : COUNT_BYE_TALANTS_FOR_COINS,
			"count_bye_talants_for_crystal" : COUNT_BYE_TALANTS_FOR_CRYSTAL,
			"count_open_chest": COUNT_OPEN_CHEST,
			"enemy_1_first_time" : ENEMY_1_FIRST_TIME,
			"enemy_2_first_time" : ENEMY_2_FIRST_TIME,
			"enemy_3_first_time" : ENEMY_3_FIRST_TIME,
			"enemy_5_first_time" : ENEMY_5_FIRST_TIME,
			"enemy_6_first_time" : ENEMY_6_FIRST_TIME,
			"enemy_8_first_time" : ENEMY_8_FIRST_TIME,
			"enemy_9_first_time" : ENEMY_9_FIRST_TIME,
			"enemy_10_first_time" : ENEMY_10_FIRST_TIME,
			"enemy_12_first_time" : ENEMY_12_FIRST_TIME,
			"enemy_13_first_time" : ENEMY_13_FIRST_TIME,
			"enemy_14_first_time" : ENEMY_14_FIRST_TIME,
			"current_character": CURRENT_CHARACTER,
			"character_1_lvl": CHARACTER_1_LVL,
			"character_2_lvl": CHARACTER_2_LVL,
			"character_3_lvl": CHARACTER_3_LVL}

func update_crystal_count(num) -> void:
	CRYSTALS_COUNT += num
	update_player_date_on_server()

func update_coins_count(num) -> void:
	COINS_COUNT += num
	update_player_date_on_server()

func update_rune_count(num) -> void:
	COUNT_RUNE += num
	update_player_date_on_server()

func update_player_date_on_server() -> void:
	YandexSDK.save_data(get_player_indicators(), true)

func player_date_loaded(data) -> void:
	if data != {}:
		COINS_COUNT = data["coins"]
		CRYSTALS_COUNT = data["crystals"]
		COUNT_RUNE = data["rune"]
		LEVEL_PLAYER = data["level_player"]
		LEVEL_EXPERIANCE_PLAYER = data["level_experiance_player"]
		LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = data["level_experiance_for_next_level"]
		CURRENT_LOCATIONS = data["current_locations"]
		MAX_WAVE_ON_CURRENT_LOCATIONS = data["max_wave_on_current_locations"]
		COUNT_BYE_TALANTS_FOR_COINS = data["count_bye_talants_for_coins"]
		COUNT_BYE_TALANTS_FOR_CRYSTAL = data["count_bye_talants_for_crystal"]
		COUNT_OPEN_CHEST = data["count_open_chest"]
		ENEMY_1_FIRST_TIME = data["enemy_1_first_time"]
		ENEMY_2_FIRST_TIME = data["enemy_2_first_time"]
		ENEMY_3_FIRST_TIME = data["enemy_3_first_time"]
		ENEMY_5_FIRST_TIME = data["enemy_5_first_time"]
		ENEMY_6_FIRST_TIME = data["enemy_6_first_time"]
		ENEMY_8_FIRST_TIME = data["enemy_8_first_time"]
		ENEMY_9_FIRST_TIME = data["enemy_9_first_time" ]
		ENEMY_10_FIRST_TIME = data["enemy_10_first_time"]
		ENEMY_12_FIRST_TIME = data["enemy_12_first_time"]
		ENEMY_13_FIRST_TIME = data["enemy_13_first_time"]
		ENEMY_14_FIRST_TIME = data["enemy_14_first_time"]
		CURRENT_CHARACTER = data["current_character"]
		CHARACTER_1_LVL = data["character_1_lvl"]
		CHARACTER_2_LVL = data["character_2_lvl"]
		CHARACTER_3_LVL = data["character_3_lvl"]
	else:
		COINS_COUNT = 500
		CRYSTALS_COUNT = 100
		COUNT_RUNE = 0
		LEVEL_PLAYER = 1
		LEVEL_EXPERIANCE_PLAYER = 0
		LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = 1000
		CURRENT_LOCATIONS = 1
		MAX_WAVE_ON_CURRENT_LOCATIONS = 0
		COUNT_BYE_TALANTS_FOR_COINS = 0
		COUNT_BYE_TALANTS_FOR_CRYSTAL = 0
		COUNT_OPEN_CHEST = 0
		ENEMY_1_FIRST_TIME = 0
		ENEMY_2_FIRST_TIME = 0
		ENEMY_3_FIRST_TIME = 0
		ENEMY_5_FIRST_TIME = 0
		ENEMY_6_FIRST_TIME = 0
		ENEMY_8_FIRST_TIME = 0
		ENEMY_9_FIRST_TIME = 0
		ENEMY_10_FIRST_TIME = 0
		ENEMY_12_FIRST_TIME = 0
		ENEMY_13_FIRST_TIME = 0
		ENEMY_14_FIRST_TIME = 0
		CURRENT_CHARACTER = 1
		CHARACTER_1_LVL = 1
		CHARACTER_2_LVL = 0
		CHARACTER_3_LVL = 0

func update_count_max_wave(max_wave) -> void:
	if max_wave > MAX_WAVE_ON_CURRENT_LOCATIONS:
		MAX_WAVE_ON_CURRENT_LOCATIONS = max_wave
		update_player_date_on_server()
	elif max_wave == 0:
		MAX_WAVE_ON_CURRENT_LOCATIONS = 0
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
		if LEVEL_PLAYER == 2:
			LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = 1250
		else:
			LEVEL_EXPERIANCE_FOR_NEXT_LEVEL = LEVEL_PLAYER * 500
	update_player_date_on_server()

func update_count_open_chest() -> void:
	COUNT_OPEN_CHEST += 1
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

func enemy_firs_time_spawn(num_enemy) -> void:
	match num_enemy:
		1:
			PlayerIndicatorsManager.ENEMY_1_FIRST_TIME = 1
			update_player_date_on_server()
		2:
			PlayerIndicatorsManager.ENEMY_2_FIRST_TIME = 1
			update_player_date_on_server()
		3:
			PlayerIndicatorsManager.ENEMY_3_FIRST_TIME = 1
			update_player_date_on_server()
		5:
			PlayerIndicatorsManager.ENEMY_5_FIRST_TIME = 1
			update_player_date_on_server()
		6:
			PlayerIndicatorsManager.ENEMY_6_FIRST_TIME = 1
			update_player_date_on_server()
		8:
			PlayerIndicatorsManager.ENEMY_8_FIRST_TIME = 1
			update_player_date_on_server()
		9:
			PlayerIndicatorsManager.ENEMY_9_FIRST_TIME = 1
			update_player_date_on_server()
		10:
			PlayerIndicatorsManager.ENEMY_10_FIRST_TIME = 1
			update_player_date_on_server()
		12:
			PlayerIndicatorsManager.ENEMY_12_FIRST_TIME = 1
			update_player_date_on_server()
		13:
			PlayerIndicatorsManager.ENEMY_13_FIRST_TIME = 1
			update_player_date_on_server()
		14:
			PlayerIndicatorsManager.ENEMY_14_FIRST_TIME = 1
			update_player_date_on_server()

func character_1_up_lvl() -> void:
	if CHARACTER_1_LVL < 20:
		CHARACTER_1_LVL += 1
		update_player_date_on_server()

func character_2_up_lvl() -> void:
	if CHARACTER_2_LVL < 20:
		CHARACTER_2_LVL += 1
		update_player_date_on_server()

func character_3_up_lvl() -> void:
	if CHARACTER_3_LVL < 20:
		CHARACTER_3_LVL += 1
		update_player_date_on_server()

func update_current_character(num) -> void:
	match num:
		1:
			CURRENT_CHARACTER = 1
			update_player_date_on_server()
		2:
			CURRENT_CHARACTER = 2
			update_player_date_on_server()
		3:
			CURRENT_CHARACTER = 3
			update_player_date_on_server()
