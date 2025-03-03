extends Node2D

func get_random_pitch() -> float:
	return randf_range(0.9, 1.1)

func click() -> void:
	$Button_click.play()

func enemy_spawn() -> void:
	$Enemy_spawn.play()

func ball_spawn() -> void:
	$Ball_spawn.pitch_scale = get_random_pitch()
	$Ball_spawn.play()
