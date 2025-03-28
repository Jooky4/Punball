extends Control

func update_characyer_1_UI() -> void:
	$VBoxContainer/TextureProgressBar.value = PlayerIndicatorsManager.CHARACTER_1_LVL
	$VBoxContainer/TextureProgressBar/Label.text = "УР: " + str(PlayerIndicatorsManager.CHARACTER_1_LVL) + "/20"
	$VBoxContainer/Attack_character/Attack_label.text = str(100 * (1 + ((PlayerIndicatorsManager.CHARACTER_1_LVL - 1) * 0.05)))
	$VBoxContainer/Attack_character/TextureRect/Attack_label_UP.text = str(100 * (1 + (PlayerIndicatorsManager.CHARACTER_1_LVL * 0.05)))
	if PlayerIndicatorsManager.CHARACTER_1_LVL < 20:
		$VBoxContainer/HP_character2/HP_label.text = str(500 * (1 + ((PlayerIndicatorsManager.CHARACTER_1_LVL - 1) * 0.05)))
		$VBoxContainer/HP_character2/TextureRect/HP_label_UP.text = str(500 * (1 + (PlayerIndicatorsManager.CHARACTER_1_LVL * 0.05)))
	else:
		$VBoxContainer/Attack_character/TextureRect.visible = false
		$VBoxContainer/HP_character2/TextureRect.visible = false
		$Need_matirial.visible = false
		$Level_UP_character_1_button/Label.text = "МАКС."
		$Level_UP_character_1_button.disabled = true

	$Need_matirial/Runes/Runes_Label.text = str(100 + (PlayerIndicatorsManager.CHARACTER_1_LVL - 1) * 20)
	if 1 <= PlayerIndicatorsManager.CHARACTER_1_LVL and PlayerIndicatorsManager.CHARACTER_1_LVL <= 5:
		$Need_matirial/Coins/Coins_Label.text = "1000"
	elif 6 <= PlayerIndicatorsManager.CHARACTER_1_LVL and PlayerIndicatorsManager.CHARACTER_1_LVL <= 10:
		$Need_matirial/Coins/Coins_Label.text = "2000"
	elif 11 <= PlayerIndicatorsManager.CHARACTER_1_LVL and PlayerIndicatorsManager.CHARACTER_1_LVL <= 15:
		$Need_matirial/Coins/Coins_Label.text = "3000"
	elif 16 <= PlayerIndicatorsManager.CHARACTER_1_LVL and PlayerIndicatorsManager.CHARACTER_1_LVL <= 19:
		$Need_matirial/Coins/Coins_Label.text = "3000"

func _on_level_up_character_1_button_pressed() -> void:
	if PlayerIndicatorsManager.CHARACTER_1_LVL < 20:
		$Level_UP_character_1_button.disabled = true
		var tween = create_tween()
		AudioManager.bye_talant_sound()
		tween.tween_property($VBoxContainer/Attack_character/Attack_label, "scale", Vector2(1.4, 1.4), 0.5).set_trans(Tween.TRANS_BACK)
		tween.chain().tween_property($VBoxContainer/Attack_character/Attack_label, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK)

		var tween1 = create_tween()
		tween1.tween_property($VBoxContainer/HP_character2/HP_label, "scale", Vector2(1.4, 1.4), 0.5).set_trans(Tween.TRANS_BACK)
		tween1.chain().tween_property($VBoxContainer/HP_character2/HP_label, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK)
		await get_tree().create_timer(1).timeout
		PlayerIndicatorsManager.character_1_up_lvl()
		update_characyer_1_UI()
		$Level_UP_character_1_button.disabled = false
