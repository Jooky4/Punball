extends Node2D

@onready var death_effect: CPUParticles2D = $Death_effect


func start_animation() -> void:
	death_effect.emitting = true


func _return_to_pool() -> void:
	ObjectPool.return_object("enemy_death_effect", self)


func _on_death_effect_finished() -> void:
	_return_to_pool()
