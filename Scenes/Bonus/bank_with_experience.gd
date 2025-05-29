extends Node2D

@onready var experience_sound = $Experience_sound
@export var experience : int = 0
@export var experience_for_label : int = 50
var bank_go = false

func go_to_count() -> void:
	bank_go = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(0, 88), 0.5).set_trans(Tween.TRANS_CIRC)
	await get_tree().create_timer(0.5).timeout
	self.visible = false

	# TODO:
	if get_tree().current_scene.has_method("get_expirians_animation"):
		bank_go = false
		get_tree().current_scene.get_expirians_animation(experience_for_label)
	self.visible = false
	experience_sound.pitch_scale += AudioManager.get_random_pitch()
	experience_sound.play()
	await get_tree().create_timer(0.6).timeout

	_return_to_pool()


func bank_with_experience() -> void:
	pass


func _return_to_pool() -> void:
	ObjectPool.return_object("experience_potion", self)
