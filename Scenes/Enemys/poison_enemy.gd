extends "res://Scenes/Enemys/defalt_enemy.gd"

@export var damage_from_explosion : int = 200
var EFFECT_EXPLOSION = preload("res://Scenes/Effects/PoisonEnemyExplosion.tscn")

func poison_enemy():
	pass

func die() -> void:
	if animation_enemy.current_animation == "Move":
		await animation_enemy.current_animation_changed
	elif animation_enemy.current_animation == "Spawn":
		await await animation_enemy.current_animation_changed
	var effect = EFFECT_EXPLOSION.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
