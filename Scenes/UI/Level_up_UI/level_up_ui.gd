extends Control

@onready var level_up_sound = $Level_up_sound
@onready var level_label = $Player_level/Player_level_label

func level_up(count_level) -> void:
	self.visible = true
	level_label.text = str(count_level)
	level_up_sound.play()

func _on_continue_pressed() -> void:
	self.visible = false
