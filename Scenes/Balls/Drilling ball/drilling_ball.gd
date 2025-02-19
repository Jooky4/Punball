extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/KillerBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	if body.has_method("enemy"):
		body.deal_damage(damage_ball * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
