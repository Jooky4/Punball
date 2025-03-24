extends Control

@onready var coins_label = $GridContainer/TextureRect3/Coins_label
@onready var crystal_label = $GridContainer/TextureRect2/Label
@onready var open_sound = $Chest_open_sound

func _ready() -> void:
	self.visible = false

func update_reward_and_show_window(count_coins, count_crystal) -> void:
	open_sound.stop()
	open_sound.play()
	crystal_label.text = str(count_crystal)
	coins_label.text = str(count_coins)
	PlayerIndicatorsManager.update_crystal_count(+count_crystal)
	PlayerIndicatorsManager.update_coins_count(+count_coins)
	self.visible = true

func _on_continue_button_pressed() -> void:
	AudioManager.click()
	self.visible = false
