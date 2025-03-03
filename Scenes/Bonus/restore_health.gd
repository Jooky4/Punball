extends Node2D

@onready var health_sound = $Health_sound
@export var health_hp = 0.1
var health_go = false

func go_to_player(pos) -> void:
	health_go = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", pos, 0.5).set_trans(Tween.TRANS_CIRC)
	await get_tree().create_timer(0.5).timeout
	self.visible = false
	if get_tree().current_scene.has_method("get_health"):
		get_tree().current_scene.get_health(health_hp * LevelManager.max_hp_player)
	self.visible = false
	health_sound.pitch_scale = AudioManager.get_random_pitch()
	health_sound.play()
	await get_tree().create_timer(1.25).timeout
	queue_free()

func health() -> void:
	pass
