extends Control

@onready var level_up_sound = $Level_up_sound
@onready var level_label = $Player_level/Player_level_label
@onready var coins_label = $GridContainer/TextureRect3/Coins_label

func level_up(count_level : float) -> void:
	self.visible = true
	coins_label.text = "x" + str((count_level / 4) * 1000)
	PlayerIndicatorsManager.update_crystal_count(+50)
	PlayerIndicatorsManager.update_coins_count((count_level / 4) * 1000)
	level_label.text = str(count_level)
	level_up_sound.play()

func _on_continue_pressed() -> void:
	self.visible = false
