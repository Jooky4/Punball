extends Node2D

@export var experience : int = 50

func go_to_count() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(0, 88), 0.5).set_trans(Tween.TRANS_CIRC)
	await get_tree().create_timer(0.5).timeout
	self.visible = false
	if get_tree().current_scene.has_method("get_expirians_animation"):
		get_tree().current_scene.get_expirians_animation(experience)
	queue_free()

func bank_with_experience() -> void:
	pass
