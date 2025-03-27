extends Control


func _on_button_pressed(extra_arg_0: int) -> void:
	AudioManager.click()
	if extra_arg_0 == 1:
		$Character_1/Label.visible = true
		$Character_2/Label.visible = false
		$Character_3/Label.visible = false
		PlayerIndicatorsManager.CURRENT_CHARACTER = 1
		PlayerIndicatorsManager.CHARACTER_UP_ATTACK = 1.0
	elif extra_arg_0 == 2:
		$Character_1/Label.visible = false
		$Character_2/Label.visible = true
		$Character_3/Label.visible = false
		PlayerIndicatorsManager.CURRENT_CHARACTER = 2
		PlayerIndicatorsManager.CHARACTER_UP_ATTACK = 1.2
	elif extra_arg_0 == 3:
		$Character_1/Label.visible = false
		$Character_2/Label.visible = false
		$Character_3/Label.visible = true
		PlayerIndicatorsManager.CURRENT_CHARACTER = 3
		PlayerIndicatorsManager.CHARACTER_UP_ATTACK = 1.5
