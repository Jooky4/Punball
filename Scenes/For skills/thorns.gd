extends Node2D

func damage_enemy(enemy) -> void:
	enemy.deal_damage(600 * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	await get_tree().create_timer(1).timeout
	queue_free()
