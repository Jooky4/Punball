extends Node2D

var damage : float = 2000
@onready var animation_trap = $AnimationPlayer
@onready var delete_trap_sound = $Delete_trap_sound

func trap() -> void:
	pass

func delete_trap(enemy) -> void:
	enemy.deal_damage(damage * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	delete_trap_sound.pitch_scale = AudioManager.get_random_pitch()
	delete_trap_sound.play()
	self.visible = false
	LevelManager.heal_hp_plaer_from_technologies()

func _on_delete_trap_sound_finished() -> void:
	queue_free()
