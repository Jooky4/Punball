extends Control

var need_cois : int = 0
var need_runes : int = 0

func _ready() -> void:
	$VBoxContainer/TextureProgressBar/Label.text = tr("CHR_LVL") + ": 0/20"


func update_characyer_2_UI() -> void:
	if PlayerIndicatorsManager.CHARACTER_2_LVL > 0:
		if PlayerIndicatorsManager.CURRENT_CHARACTER == 2:
			$Select_character.disabled = true
			$Select_character/Label.text = tr("CHR_SELECTED")
		else:
			$Select_character.disabled = false
			$Select_character/Label.text = tr("CHR_SELECT")

		$BuyButton.visible = false
		$Level_UP_character_2_button.visible = true
		$Need_matirial.visible = true
		$Select_character.visible = true
		$VBoxContainer/Attack_character/TextureRect.visible = true
		$VBoxContainer/Attack_character/Attack_UP.visible = true
		$VBoxContainer/HP_character/TextureRect3.visible = true
		$VBoxContainer/HP_character/HP_UP.visible = true
		$VBoxContainer/TextureProgressBar.value = PlayerIndicatorsManager.CHARACTER_2_LVL
		$VBoxContainer/TextureProgressBar/Label.text = tr("CHR_LVL") + ": " + str(PlayerIndicatorsManager.CHARACTER_2_LVL) + "/20"
		$VBoxContainer/Attack_character/Attack_label.text = str(120 * (1 + ((PlayerIndicatorsManager.CHARACTER_2_LVL - 1) * 0.05)))
		$VBoxContainer/Attack_character/Attack_UP.text = str(120 * (1 + (PlayerIndicatorsManager.CHARACTER_2_LVL * 0.05)))
		$VBoxContainer/HP_character/HP_label.text = str(600 * (1 + ((PlayerIndicatorsManager.CHARACTER_2_LVL - 1) * 0.05)))
		$VBoxContainer/HP_character/HP_UP.text = str(600 * (1 + (PlayerIndicatorsManager.CHARACTER_2_LVL * 0.05)))

		$Need_matirial/Runes/Runes_Label.text = str(100 + (PlayerIndicatorsManager.CHARACTER_2_LVL - 1) * 20)
		need_runes = (100 + (PlayerIndicatorsManager.CHARACTER_2_LVL - 1) * 20)

		var upgrade_cost_coins_label = $Need_matirial/Coins/Coins_Label
		if 1 <= PlayerIndicatorsManager.CHARACTER_2_LVL and PlayerIndicatorsManager.CHARACTER_2_LVL <= 5:
			need_cois = Constants.HERO_UPGRADE_COST.STAGE_1
			upgrade_cost_coins_label.text = str(need_cois)
		elif 6 <= PlayerIndicatorsManager.CHARACTER_2_LVL and PlayerIndicatorsManager.CHARACTER_2_LVL <= 10:
			need_cois = Constants.HERO_UPGRADE_COST.STAGE_2
			upgrade_cost_coins_label.text = str(need_cois)
		elif 11 <= PlayerIndicatorsManager.CHARACTER_2_LVL and PlayerIndicatorsManager.CHARACTER_2_LVL <= 15:
			need_cois = Constants.HERO_UPGRADE_COST.STAGE_3
			upgrade_cost_coins_label.text = str(need_cois)
		elif 16 <= PlayerIndicatorsManager.CHARACTER_2_LVL and PlayerIndicatorsManager.CHARACTER_2_LVL <= 19:
			need_cois = Constants.HERO_UPGRADE_COST.STAGE_4
			upgrade_cost_coins_label.text = str(need_cois)

		if PlayerIndicatorsManager.CHARACTER_2_LVL < 20:
			if PlayerIndicatorsManager.COINS_COUNT >= need_cois and PlayerIndicatorsManager.COUNT_RUNE >= need_runes:
				$Level_UP_character_2_button.disabled = false
			else:
				$Level_UP_character_2_button.disabled = true
		else:
			$VBoxContainer/Attack_character/TextureRect.visible = false
			$VBoxContainer/HP_character/TextureRect3.visible = false
			$VBoxContainer/Attack_character/Attack_UP.visible = false
			$VBoxContainer/HP_character/HP_UP.visible = false
			$Need_matirial.visible = false
			$Level_UP_character_2_button/Label.text = tr("CHR_MAX")
			$Level_UP_character_2_button.disabled = true
			$Level_UP_character_2_button

func _on_level_up_character_2_button_pressed() -> void:
	if PlayerIndicatorsManager.CHARACTER_2_LVL < 20 and PlayerIndicatorsManager.COINS_COUNT >= need_cois and PlayerIndicatorsManager.COUNT_RUNE >= need_runes:
		AudioManager.click()
		$"..".can_or_not_update()
		$Level_UP_character_2_button.disabled = true
		var tween = create_tween()
		PlayerIndicatorsManager.update_coins_count(-need_cois)
		PlayerIndicatorsManager.update_rune_count(-need_runes)
		$"../..".update_coins_label()
		$"../..".update_rune_label()
		$"../..".update_visible_texture_can_update()
		AudioManager.bye_talant_sound()
		tween.tween_property($VBoxContainer/Attack_character/Attack_label, "scale", Vector2(1.4, 1.4), 0.5).set_trans(Tween.TRANS_BACK)
		tween.chain().tween_property($VBoxContainer/Attack_character/Attack_label, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK)

		var tween1 = create_tween()
		tween1.tween_property($VBoxContainer/HP_character/HP_label, "scale", Vector2(1.4, 1.4), 0.5).set_trans(Tween.TRANS_BACK)
		tween1.chain().tween_property($VBoxContainer/HP_character/HP_label, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK)
		await get_tree().create_timer(1).timeout
		PlayerIndicatorsManager.character_2_up_lvl()
		$"..".can_or_not_update()
		$Level_UP_character_2_button.disabled = false

func _on_select_character_pressed() -> void:
	AudioManager.click()
	PlayerIndicatorsManager.update_current_character(2)
	update_characyer_2_UI()
