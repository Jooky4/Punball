extends Control


func update_discription(new_discription) -> void:
	$Discription_skill.visible = true
	$Discription_skill.text = new_discription

func show_rarity_window(rarity : int) -> void:
	match rarity:
		1:
			$regular_window.visible = true
		2:
			$rare_window.visible = true
		3:
			$epic_window.visible = true
		4:
			$legendary_window.visible = true
