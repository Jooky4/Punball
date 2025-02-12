extends "res://Scenes/Enemys/defalt_enemy_2.gd"


func moving(direction_object) -> void:
	create_tween().tween_property(self, "position", Vector2(103, 103) * Vector2(direction_object.y, direction_object.x), 1).as_relative()

func create_label_damage(damage_ball, color_label) -> void:
	var label = LABEL_DAMAGE.instantiate()
	label.global_position = self.global_position
	label.text = "-" + str(damage_ball)
	label.modulate = color_label
	label.scale = Vector2(start_scale_damage_label, start_scale_damage_label)
	get_tree().current_scene.add_child(label)
	label.show_label(150)

func boss() -> void:
	pass
