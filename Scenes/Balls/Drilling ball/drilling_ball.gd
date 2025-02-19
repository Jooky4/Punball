extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

func collide_with_enemy(collider) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		body.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
