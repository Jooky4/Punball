extends Control

@onready var shop_UI = $Shop
@onready var main_menu_UI = $Main_menu
@onready var talents_UI = $Talents
@onready var characters_UI = $Characters
@onready var location_sprite = $Main_menu/Locations/Location_sprite
@onready var location_name_label = $Main_menu/Location_name
@onready var chests = $Main_menu/Chests

@onready var crystals_label = $Player_state/Crystals/Crystals_label
@onready var coins_label = $Player_state/Coins/Coins_label
@onready var rune_label = $Characters/Runes_count/Runes_label
@onready var max_wave_on_locations_label = $Main_menu/Location_name/Max_wave_on_locations

@onready var player_leve_UI = $Player_state/Player_level
@onready var player_level_label = $Player_state/Player_level/Player_level_label
@onready var player_level_bar = $Player_state/Player_level/Player_level_bar

@onready var play_button = $Main_menu/PLay_button
var button_play_disabled = preload("res://Texture/UI/Main_menu/кнопка Играть не активна.png")
var button_play_can_press = preload("res://Texture/UI/Main_menu/кнопка Играть.png")

var location = {
	0 : [preload("res://Texture/UI/Main_menu/Location/1.png"), "Лихолесье"],
	1 : [preload("res://Texture/UI/Main_menu/Location/2.png"), "Пустыня"],
	2 : [preload("res://Texture/UI/Main_menu/Location/3.png"), "Замок"],
	3 : [preload("res://Texture/UI/Main_menu/Location/4.png"), "Туманграф"],
	4 : [preload("res://Texture/UI/Main_menu/Location/5.png"), "Эфирион"],
	5 : [preload("res://Texture/UI/Main_menu/Location/6.png"), "Ржавник"],
	6 : [preload("res://Texture/UI/Main_menu/Location/7.png"), "Лунарис"],
	7 : [preload("res://Texture/UI/Main_menu/Location/1.png"), "Шептоль"],
	8 : [preload("res://Texture/UI/Main_menu/Location/1.png"), "Пламеград"],
	-1 : [preload("res://Texture/UI/Main_menu/Location/1.png"), "Безднария"]
}
var current_location = 1
var number_cycle = 0

var rim_num_location = []

var count_wave_on_locations = {
	0: 20,
	1: 20,
	2: 30,
	3: 20,
	4: 40,
	5: 20,
	6: 20,
	7: 30,
	8: 20,
	-1: 40
}

var load_not_buy = false

func _ready() -> void:
	Engine.time_scale = 1
	get_tree().paused = false
	YandexSDK.connect("game_initialized", update_player_indicators)
	YandexSDK.connect("data_loaded", player_date_loaded)
	YandexSDK.connect('purchased', _process_purchase_with_token)
	YandexSDK.connect("unprocessed_purchases_loaded", _process_uncompleted_purchases)
	for i in range(1, 1001):
		rim_num_location.append(arabic_to_roman(i))
	if PlayerIndicatorsManager.SHOW_AD_FIRST_TIME == false:
		YandexSDK.init_game()
		YandexSDK.init_player() 
		YandexSDK.game_ready()
		AudioManager.music_start()

		if !YandexSDK.game_initialized:
			await YandexSDK.game_initialized
		update_player_indicators()

		main_menu_UI.visible = true
		shop_UI.visible = false
		characters_UI.visible = false

		YandexSDK.show_interstitial_ad()
		PlayerIndicatorsManager.SHOW_AD_FIRST_TIME = true
	else:
		update_player_indicators()
		main_menu_UI.visible = true
		shop_UI.visible = false
		characters_UI.visible = false

func _process_purchase_with_token(product_id: String, token: String):
	_process_purchase(product_id, token)

func _process_uncompleted_purchases(data):
	print("Processing purchases count:", len(data))
	for purchase in data:
		var product_id = purchase.get("product_id")
		var token = purchase.get("purchase_token")
		if not product_id or not token:
			push_error("Invalid purchase item: ", purchase)
			continue
		print("Processing:", product_id, "|", token)
		_process_purchase(product_id, token)

func _process_purchase(id_buy, token) -> void:
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

	update_coins_label()
	update_crystal_label()

	YandexSDK.consume_purchase(token)
	print("Purchase consumed:", id_buy)

func update_player_indicators() -> void:
	PlayerIndicatorsManager.update_player_date_in_game()
	AudioManager.music_start()

func arabic_to_roman(num: int) -> String:
	var val = [1000, 900, 500, 400,100, 90, 50, 40,10, 9, 5, 4, 1]
	var syms = ["M", "CM", "D", "CD","C", "XC", "L", "XL","X", "IX", "V", "IV","I"]
	var roman_num = ""
	var i = 0
	while num > 0:
		for j in range(num / val[i]):
			roman_num += syms[i]
			num -= val[i]
		i += 1
	return roman_num

func player_date_loaded(data) -> void:
	update_cuurent_location_texture()
	check_tutorial()
	update_coins_label()
	update_crystal_label()
	update_characte_UI()
	update_level_label_and_bar()
	talents_UI.update_skill()
	talents_UI.update_player_indicator_talant_for_coins()
	chests.update_label_chests()
	can_by_new_talant()
	$Select_buttons/Talesnts_button.disabled = false
	if load_not_buy == false:
		load_not_buy = true
		YandexSDK.check_unprocessed_purchases()

func check_tutorial() -> void:
	if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 0 and current_location == 1:
		PlayerIndicatorsManager.CURRENT_LOCATIONS = current_location
		WaveGeneration.current_location = PlayerIndicatorsManager.CURRENT_LOCATIONS
		LevelManager.restert()
		LevelManager.player_balls = [1, 1, 1, 1]
		get_tree().change_scene_to_file("res://Scenes/Levels/first_level.tscn")
	elif PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 1 and PlayerIndicatorsManager.TALANTS_TUTORIL == 0:
		$Tutorial_talants.visible = true
		$"Tutorial_talants/1_step".visible = true
	elif PlayerIndicatorsManager.TALANTS_TUTORIL == 1:
		$Tutorial_talants.visible = false

func step_2_tutorial() -> void:
	if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 1 and PlayerIndicatorsManager.TALANTS_TUTORIL == 0:
		$"Tutorial_talants/1_step".visible = false

func step_3_tutorial() -> void:
	if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 1 and PlayerIndicatorsManager.TALANTS_TUTORIL == 0:
		$"Tutorial_talants/1_step".visible = false

func end_tutorial() -> void:
	$Tutorial_talants.visible = false
	PlayerIndicatorsManager.TALANTS_TUTORIL = 1
	PlayerIndicatorsManager.update_player_date_on_server()

func update_coins_label() -> void:
	coins_label.text = str(PlayerIndicatorsManager.get_player_indicators()["coins"])

func update_crystal_label() -> void:
	crystals_label.text = str(PlayerIndicatorsManager.get_player_indicators()["crystals"])

func update_level_label_and_bar() -> void:
	player_level_label.text = str(PlayerIndicatorsManager.LEVEL_PLAYER)
	player_level_bar.max_value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_FOR_NEXT_LEVEL
	player_level_bar.value = PlayerIndicatorsManager.LEVEL_EXPERIANCE_PLAYER

func update_cuurent_location_texture() -> void:
	current_location = PlayerIndicatorsManager.CURRENT_LOCATIONS
	if current_location <= 10008:
		location_sprite.texture = location[(current_location % 10) - 1][0]
		if current_location > 10:
			location_name_label.text = str(location[(current_location % 10) - 1][1])  + " "  + str(rim_num_location[((current_location - 1) / 10) - 1])
		else:
			location_name_label.text = location[(current_location % 10) - 1][1]
		max_wave_on_locations_label.text = "максимальный уровень " + str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS) + "/" + str(count_wave_on_locations[(current_location % 10) - 1])

func update_characte_UI() -> void:
	if PlayerIndicatorsManager.LEVEL_PLAYER < 5:
		$Select_buttons/Character_button/Not_can_press.visible = true
		$Select_buttons/Character_button/Can_press.visible = false
		#$Select_buttons/Character_button.texture_normal = load("res://Texture/UI/Main_menu/панель для иконок не активна.png")
		$Select_buttons/Character_button.disabled = true
	else:
		$Select_buttons/Character_button.disabled = false
		characters_UI.can_or_not_update()
		characters_UI.update_ui()
		update_rune_label()

func update_rune_label() -> void:
	rune_label.text = str(PlayerIndicatorsManager.COUNT_RUNE)

func _on_button_pressed() -> void:
	#AudioManager.click()
	#ChangeScene.black_screen()
	#PlayerIndicatorsManager.CURRENT_LOCATIONS = current_location
	#WaveGeneration.current_location = PlayerIndicatorsManager.CURRENT_LOCATIONS
	#LevelManager.restert()
	#LevelManager.player_balls = [1, 1, 1, 1]
	#AudioServer.set_bus_mute(0, false)
	#await get_tree().create_timer(0.35).timeout
	#get_tree().change_scene_to_file("res://Scenes/Levels/first_level.tscn")
	AudioManager.click()
	YandexSDK.show_interstitial_ad()
	YandexSDK.connect("interstitial_ad", star_location)

func star_location(result) -> void:
	if result == "closed" or result == "error":
		ChangeScene.black_screen()
		PlayerIndicatorsManager.CURRENT_LOCATIONS = current_location
		WaveGeneration.current_location = PlayerIndicatorsManager.CURRENT_LOCATIONS
		LevelManager.restert()
		LevelManager.player_balls = [1, 1, 1, 1]
		AudioServer.set_bus_mute(0, false)
		await get_tree().create_timer(0.35).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/first_level.tscn")
	elif result == "opened":
		AudioServer.set_bus_mute(0, true)

func _on_shop_button_pressed() -> void:
	AudioManager.click()
	if shop_UI.visible == false:
		return_norm_scale()
		update_button_scale(1)
	shop_UI.visible = true
	player_leve_UI.visible = true
	main_menu_UI.visible = false
	talents_UI.visible = false
	characters_UI.visible = false

func _on_talesnts_button_pressed() -> void:
	AudioManager.click()
	if talents_UI.visible == false:
		return_norm_scale()
		update_button_scale(3)
	if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 1 and PlayerIndicatorsManager.TALANTS_TUTORIL == 0:
		$"Tutorial_talants/1_step".visible = false
	talents_UI.visible = true
	player_leve_UI.visible = true
	main_menu_UI.visible = false
	shop_UI.visible = false
	characters_UI.visible = false
	talents_UI.update_skill()

func _on_next_location_pressed() -> void:
	AudioManager.click()
	if current_location <= 10008:
		current_location += 1
		location_sprite.texture = location[(current_location % 10) - 1][0]
		if current_location > 10:
			location_name_label.text = str(location[(current_location % 10) - 1][1])  + " "  + str(rim_num_location[((current_location - 1) / 10) - 1])
		else:
			location_name_label.text = location[(current_location % 10) - 1][1]
		max_wave_on_locations_label.text = "максимальный уровень " + str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS) + "/" + str(count_wave_on_locations[(current_location % 10) - 1])

func _on_back_location_pressed() -> void:
	AudioManager.click()
	if current_location - 1 >= 1:
		current_location -= 1
		location_sprite.texture = location[(current_location % 10) - 1][0]
		if current_location > 10:
			location_name_label.text = str(location[(current_location % 10) - 1][1])  + " "  + str(rim_num_location[((current_location - 1) / 10) - 1])
		else:
			location_name_label.text = location[(current_location % 10) - 1][1]
		max_wave_on_locations_label.text = "максимальный уровень " + str(PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS) + "/" + str(count_wave_on_locations[(current_location % 10) - 1])

func _on_mainmenu_button_pressed() -> void:
	AudioManager.click()
	if main_menu_UI.visible == false:
		return_norm_scale()
		update_button_scale(2)
	if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 1 and PlayerIndicatorsManager.TALANTS_TUTORIL == 0:
		$"Tutorial_talants/1_step".visible = true
	main_menu_UI.visible = true
	player_leve_UI.visible = true
	shop_UI.visible = false
	talents_UI.visible = false
	characters_UI.visible = false

func _on_character_button_pressed() -> void:
	AudioManager.click()
	if characters_UI.visible == false:
		return_norm_scale()
		update_button_scale(4)
	characters_UI.visible = true
	main_menu_UI.visible = false
	player_leve_UI.visible = false
	shop_UI.visible = false
	talents_UI.visible = false
	characters_UI._on_back_button_pressed()

func can_by_new_talant() -> void:
	var crystal_cost = 0
	var need_lvl_to_by_crystal : int = 0
	$Select_buttons/Talesnts_button/Can_by.visible = false
	for i in range(1, PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_CRYSTAL + 2):
		if i == 1:
			crystal_cost = 200
			need_lvl_to_by_crystal = 1
		elif i == 2:
			crystal_cost = 200
			need_lvl_to_by_crystal = 2
		else:
			need_lvl_to_by_crystal = (i - 1) * 2
			crystal_cost = 300 * (((i - 3) / 6) + 1)
	if PlayerIndicatorsManager.CRYSTALS_COUNT >= crystal_cost and need_lvl_to_by_crystal <= PlayerIndicatorsManager.LEVEL_PLAYER:
		$Select_buttons/Talesnts_button/Can_by.visible = true

	var coins_cost = 0
	var need_lvl_to_by_coins : int = 0
	for i in range(1, PlayerIndicatorsManager.COUNT_BYE_TALANTS_FOR_COINS + 2):
		coins_cost = 500 + (1250 * ((i - 1) / 5))
		need_lvl_to_by_coins = ((i - 1) / 3) + 1
	if PlayerIndicatorsManager.COINS_COUNT >= coins_cost and need_lvl_to_by_coins <= PlayerIndicatorsManager.LEVEL_PLAYER:
		$Select_buttons/Talesnts_button/Can_by.visible = true

func update_button_scale(what_menu):
	match what_menu:
		1:
			create_tween().tween_property($Select_buttons/Shop_button/TextureRect, "scale", Vector2(1.1, 1.1), 0.1)
			create_tween().tween_property($Select_buttons/Shop_button/TextureRect, "position", $Select_buttons/Shop_button/TextureRect.position + Vector2(0, -30), 0.1)
			$Select_buttons/Shop_button/Label.visible = true
		2:
			create_tween().tween_property($Select_buttons/Main_menu_button/TextureRect, "scale", Vector2(1.1, 1.1), 0.1)
			create_tween().tween_property($Select_buttons/Main_menu_button/TextureRect, "position", $Select_buttons/Main_menu_button/TextureRect.position + Vector2(0, -30), 0.1)
			$Select_buttons/Main_menu_button/Label.visible = true
		3:
			create_tween().tween_property($Select_buttons/Talesnts_button/TextureRect, "scale", Vector2(1.1, 1.1), 0.1)
			create_tween().tween_property($Select_buttons/Talesnts_button/TextureRect, "position", $Select_buttons/Talesnts_button/TextureRect.position + Vector2(0, -30), 0.1)
			$Select_buttons/Talesnts_button/Label.visible = true
		4:
			create_tween().tween_property($Select_buttons/Character_button/Can_press, "scale", Vector2(1.1, 1.1), 0.1)
			create_tween().tween_property($Select_buttons/Character_button/Can_press, "position", $Select_buttons/Character_button/Can_press.position + Vector2(0, -30), 0.1)
			$Select_buttons/Character_button/Label.visible = true

func return_norm_scale():
	if shop_UI.visible:
		create_tween().tween_property($Select_buttons/Shop_button/TextureRect, "scale", Vector2(1, 1), 0.1)
		create_tween().tween_property($Select_buttons/Shop_button/TextureRect, "position", $Select_buttons/Shop_button/TextureRect.position + Vector2(0, 30), 0.1)
		$Select_buttons/Shop_button/Label.visible = false
	if main_menu_UI.visible:
		create_tween().tween_property($Select_buttons/Main_menu_button/TextureRect, "scale", Vector2(1, 1), 0.1)
		create_tween().tween_property($Select_buttons/Main_menu_button/TextureRect, "position", $Select_buttons/Main_menu_button/TextureRect.position + Vector2(0, 30), 0.1)
		$Select_buttons/Main_menu_button/Label.visible = false
	if talents_UI.visible:
		create_tween().tween_property($Select_buttons/Talesnts_button/TextureRect, "scale", Vector2(1, 1), 0.1)
		create_tween().tween_property($Select_buttons/Talesnts_button/TextureRect, "position", $Select_buttons/Talesnts_button/TextureRect.position + Vector2(0, 30), 0.1)
		$Select_buttons/Talesnts_button/Label.visible = false
	if characters_UI.visible:
		create_tween().tween_property($Select_buttons/Character_button/Can_press, "scale", Vector2(1, 1), 0.1)
		create_tween().tween_property($Select_buttons/Character_button/Can_press, "position", $Select_buttons/Character_button/Can_press.position + Vector2(0, 30), 0.1)
		$Select_buttons/Character_button/Label.visible = false
