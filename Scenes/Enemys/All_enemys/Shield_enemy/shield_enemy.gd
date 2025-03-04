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
