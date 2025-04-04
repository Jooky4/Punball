extends Control

func _ready() -> void:
	$All_characters.visible = true
	$Character_1_window.visible = false
	$Character_2_window.visible = false
	$Character_3_window.visible = false
	$Back_button.visible = false

func _on_back_button_pressed() -> void:
	AudioManager.click()
	update_ui()

func _on_button_buy_2_pressed() -> void:
	AudioManager.click()
	$All_characters.visible = false
	$Character_1_window.visible = false
	$Character_2_window.update_characyer_2_UI()
	$Character_2_window.visible = true
	$Character_3_window.visible = false
	$Back_button.visible = true

func _on_button_buy_3_pressed() -> void:
	AudioManager.click()
	$All_characters.visible = false
	$Character_1_window.visible = false
	$Character_2_window.visible = false
	$Character_3_window.update_characyer_3_UI()
	$Character_3_window.visible = true
	$Back_button.visible = true

func _on_button_1_character_pressed() -> void:
	AudioManager.click()
	$All_characters.visible = false
	$Character_1_window.update_characyer_1_UI()
	$Character_1_window.visible = true
	$Character_2_window.visible = false
	$Character_3_window.visible = false
	$Back_button.visible = true

func _on_buy_2_hero_button_pressed() -> void:
	if PlayerIndicatorsManager.CRYSTALS_COUNT >= 1000:
		AudioManager.click()
		PlayerIndicatorsManager.update_crystal_count(-1000)
		$"..".update_crystal_label()
		$All_characters/HBoxContainer/Character_2.visible = true
		$All_characters/HBoxContainer2/Character_2.visible = false
		PlayerIndicatorsManager.character_2_up_lvl()
		$Character_2_window.update_characyer_2_UI()
		can_or_not_update()

func _on_buy_button_pressed() -> void:
	if PlayerIndicatorsManager.CRYSTALS_COUNT >= 1500:
		AudioManager.click()
		PlayerIndicatorsManager.update_crystal_count(-1500)
		$"..".update_crystal_label()
		$All_characters/HBoxContainer/Character_3.visible = true
		$All_characters/HBoxContainer2/Character_3.visible = false
		PlayerIndicatorsManager.character_3_up_lvl()
		$Character_3_window.update_characyer_3_UI()
		can_or_not_update()

func can_or_not_update() -> void:
	$"../Select_buttons/Character_button/Can_update".visible = false
	$All_characters/HBoxContainer/Character_1/TextureRect/Can_update.visible = false
	$All_characters/HBoxContainer/Character_2/TextureRect/Can_update.visible = false
	$All_characters/HBoxContainer/Character_3/TextureRect/Can_update.visible = false

	$Character_1_window.update_characyer_1_UI()
	if $Character_1_window.need_cois <= PlayerIndicatorsManager.COINS_COUNT and $Character_1_window.need_runes <= PlayerIndicatorsManager.COUNT_RUNE and PlayerIndicatorsManager.CHARACTER_1_LVL < 20:
		$"../Select_buttons/Character_button/Can_update".visible = true
		$All_characters/HBoxContainer/Character_1/TextureRect/Can_update.visible = true

	if PlayerIndicatorsManager.CHARACTER_2_LVL > 0:
		$Character_2_window.update_characyer_2_UI()
		if $Character_2_window.need_cois <= PlayerIndicatorsManager.COINS_COUNT and $Character_2_window.need_runes <= PlayerIndicatorsManager.COUNT_RUNE and PlayerIndicatorsManager.CHARACTER_2_LVL < 20:
			$"../Select_buttons/Character_button/Can_update".visible = true
			$All_characters/HBoxContainer/Character_2/TextureRect/Can_update.visible = true

	if PlayerIndicatorsManager.CHARACTER_3_LVL > 0:
		$Character_3_window.update_characyer_3_UI()
		if $Character_3_window.need_cois <= PlayerIndicatorsManager.COINS_COUNT and $Character_3_window.need_runes <= PlayerIndicatorsManager.COUNT_RUNE and PlayerIndicatorsManager.CHARACTER_3_LVL < 20:
			$"../Select_buttons/Character_button/Can_update".visible = true
			$All_characters/HBoxContainer/Character_3/TextureRect/Can_update.visible = true

func update_ui() -> void:
	$All_characters/HBoxContainer/Character_1/TextureRect/Lvl.text = str(PlayerIndicatorsManager.CHARACTER_1_LVL)
	$All_characters/HBoxContainer/Character_2/TextureRect/Lvl.text = str(PlayerIndicatorsManager.CHARACTER_2_LVL)
	$All_characters/HBoxContainer/Character_3/TextureRect/Lvl.text = str(PlayerIndicatorsManager.CHARACTER_3_LVL)

	$All_characters/HBoxContainer/Character_1/Select.visible = false
	$All_characters/HBoxContainer/Character_2/Select.visible = false
	$All_characters/HBoxContainer/Character_3/Select.visible = false

	if PlayerIndicatorsManager.CHARACTER_2_LVL > 0:
		$All_characters/HBoxContainer/Character_2.visible = true
		$All_characters/HBoxContainer2/Character_2.visible = false
	if PlayerIndicatorsManager.CHARACTER_3_LVL > 0:
		$All_characters/HBoxContainer/Character_3.visible = true
		$All_characters/HBoxContainer2/Character_3.visible = false

	match PlayerIndicatorsManager.CURRENT_CHARACTER:
		1:
			$All_characters/HBoxContainer/Character_1/Select.visible = true
		2:
			$All_characters/HBoxContainer/Character_2/Select.visible = true
		3:
			$All_characters/HBoxContainer/Character_3/Select.visible = true
	$All_characters.visible = true
	$Character_1_window.visible = false
	$Character_2_window.visible = false
	$Character_3_window.visible = false
	$Back_button.visible = false
