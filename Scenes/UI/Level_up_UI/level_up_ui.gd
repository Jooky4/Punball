extends Control

@onready var level_up_sound = $Level_up_sound
@onready var level_label = $Player_level/Player_level_label
@onready var coins_label = $GridContainer/TextureRect3/Coins_label


func level_up(count_level: int) -> void:
	self.visible = true
	var coins_count: int = (count_level / 4.0) * 1000
	coins_label.text = "x" + str(coins_count)
	PlayerIndicatorsManager.update_crystal_count(+50)
	PlayerIndicatorsManager.update_coins_count(coins_count)
	level_label.text = str(count_level)
	level_up_sound.play()


func _on_continue_pressed() -> void:
	self.visible = false
