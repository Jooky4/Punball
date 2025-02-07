extends Control

var discription = ""

func update_discription(new_discription) -> void:
	discription = new_discription

func show_rarity_window(rarity : int) -> void:
	$Discription_skill.visible = false
	$regular_window.visible = false
	$rare_window.visible = false
	$epic_window.visible = false
	$legendary_window.visible = false
	$AnimationPlayer.play("RESET")
	match rarity:
		1:
			$regular_window.visible = true
			$AnimationPlayer.play("regular_window")
		2:
			$regular_window.visible = true
			$rare_window.visible = true
			$AnimationPlayer.play("rare_window")
		3:
			$regular_window.visible = true
			$rare_window.visible = true
			$epic_window.visible = true
			$AnimationPlayer.play("epic_window")
		4:
			$regular_window.visible = true
			$rare_window.visible = true
			$epic_window.visible = true
			$legendary_window.visible = true
			$AnimationPlayer.play("legend_window")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Discription_skill.visible = true
	$Discription_skill.text = discription
