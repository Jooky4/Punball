extends "res://Scenes/Enemys/All_enemys/Fire_elemental_enemy/fire_elemental_enemy.gd"

@onready var boss_move = $Boss_move

func is_boss() -> bool:
	return true

func moving(direction_object) -> void:
	if alive:
		on_last_line = false
		animation_enemy.play("Move")
		boss_move.play()
		create_tween().tween_property(self, "position", Vector2(103, 103) * Vector2(direction_object.y, direction_object.x), 1).as_relative().set_trans(Tween.TRANS_QUAD)
		await get_tree().create_timer(1).timeout
		if on_last_line:
			animation_enemy.play("Preparation")
		else:
			animation_enemy.play("Idle")

func create_label_damage(damage_ball, color_label) -> void:
	var label = ObjectPool.get_object("enemy_damage_label")
	label.global_position = self.global_position
	if typeof(damage_ball) != 3 and typeof(damage_ball) != 2:
		label.text = str(damage_ball)
	elif color_label == ElementsManager.color_elements["HEAL"]:
		label.text = "+" + str(roundi(damage_ball))
	else:
		label.text = "-" + str(roundi(damage_ball))
	label.modulate = color_label
	label.scale = Vector2(start_scale_damage_label, start_scale_damage_label)
	get_tree().current_scene.add_child(label)
	label.show_label2(125)

func get_bullet_pos() -> Vector2:
	return Vector2(47, 108)

func boss() -> void:
	pass
