extends Node2D

var count_pos

func go(end_pos, count_pos_) -> void:
	count_pos = count_pos_
	var tween = create_tween()
	tween.tween_property(self, "global_position", (self.global_position + end_pos), 0.8)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
