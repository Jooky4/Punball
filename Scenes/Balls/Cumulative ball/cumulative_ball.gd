extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/CumulativeBallExplosion.tscn")

func collide_with_enemy(collider) -> void:
	collider.deal_fire_damage(damage_ball * ElementsManager.nuclear_modifier, ElementsManager.color_elements["NUCLEAR"])
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	queue_free()
