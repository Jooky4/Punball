extends Node2D

var arc_height = -150
var count_pos

func go(end_pos, count_pos_) -> void:
	count_pos = count_pos_
	var tween = create_tween()
	tween.tween_property(self, "global_position", (self.global_position + end_pos), 0.5).set_trans(Tween.TRANS_CIRC)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if get_tree().current_scene.has_method("spawn_objects_by_index"):
		LevelManager.first_level_links_on_objects[count_pos/6][count_pos%6] = 7
		get_tree().get_current_scene().call("spawn_objects_by_index", count_pos)
	queue_free()
