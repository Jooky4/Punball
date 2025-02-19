extends Sprite2D

var damage : float = 1500

func trap() -> void:
	pass

func delete_trap(enemy) -> void:
	await get_tree().create_timer(1).timeout
	enemy.deal_damage(damage * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	queue_free()
