extends "res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.gd"

@onready var detection_ball = $Area2D

func shiield_enemy() -> void:
	pass

func can_ball_deal_damage() -> bool:
	var ball_array = detection_ball.get_overlapping_bodies()
	if ball_array != []:
		animation_enemy.play("Block")
		return false
	return true

func create_label_damage(damage_ball, color_label) -> void:
	var label = LABEL_DAMAGE.instantiate()
	label.global_position = self.global_position
	if typeof(damage_ball) != 3 and typeof(damage_ball) != 2:
		label.text = str(damage_ball)
	elif color_label == ElementsManager.color_elements["HEAL"]:
		label.text = "+" + str(round(damage_ball))
	else:
		label.text = "-" + str(round(damage_ball))
	label.modulate = color_label
	label.scale = Vector2(start_scale_damage_label, start_scale_damage_label)
	get_tree().current_scene.add_child(label)
	label.show_label(125)

func boss() -> void:
	pass

func play_animation_hit_player(player_position):
	if animation_enemy and alive: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("Hit")
		hit_sound.pitch_scale += AudioManager.get_random_pitch()
		hit_sound.play()
		var self_position = self.position
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", player_position + Vector2(-90, -140), 0.5)
		tween.chain().tween_property(self, "position", self_position, 0.5)
