extends Control


func _ready() -> void:
	visible = false

func _on_continue_game_pressed() -> void:
	LevelManager.spin_skill -= 1
	if LevelManager.spin_skill == 0:
		visible = false
	else:
		get_number_skill(LevelManager.spin_skill)

func get_number_skill(number:int) -> void:
	$Label.text = "ЗДЕСЬ БУДЕМ ПОЛУЧАТЬ СКИЛЛ " + str(number)
