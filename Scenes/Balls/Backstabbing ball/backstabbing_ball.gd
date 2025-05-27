extends "res://Scenes/Balls/Defalt ball/defalt_ball.gd"

var EFFECT_BALL = preload("res://Scenes/Effects/BackstabbingBallExplosion.tscn")


func _physics_process(delta) -> void:
	line_trail.add_point(self.global_position + (direction_bullet * 14))
	if line_trail.points.size() > max_lenght_line:
		line_trail.remove_point(0)

	super(delta)


func collide_with_enemy(collider) -> void:
	var effect = EFFECT_BALL.instantiate()
	effect.global_position = self.global_position
	get_tree().current_scene.add_child(effect)
	play_sound("hit_enemy_shuriken")

	var position_enemy = collider.get_global_position()
	if collider.has_method("boss"):
		var cell_size = 104
		position_enemy.x += cell_size * 0.5
		position_enemy.y += cell_size * 0.5
	var self_position = self.get_global_position()
	var delta_x = position_enemy.x - self_position.x
	var delta_y = position_enemy.y - self_position.y
	var damage_ball_plus = 0
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball_plus = round(damage_ball * 0.05)
	if abs(delta_x) > abs(delta_y):
		if delta_x > 0:
			collider.deal_damage((damage_ball + damage_ball_plus) * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
		else:
			collider.deal_damage((damage_ball + damage_ball_plus) * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
	else:
		if delta_y > 0:
			collider.deal_damage((1000 + damage_ball_plus) * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])
		else:
			collider.deal_damage((damage_ball + damage_ball_plus) * ElementsManager.technologies_modifier, ElementsManager.color_elements["TECHNOLOGIES"])

	LevelManager.heal_hp_plaer_from_technologies()
