extends Node2D

var damage : float = 1500
@onready var animation_trap = $AnimationPlayer

func trap() -> void:
	pass

func delete_trap(enemy) -> void:
	enemy.deal_damage(damage * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	LevelManager.heal_hp_plaer_from_technologies()
	queue_free()
