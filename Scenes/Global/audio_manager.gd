extends Node2D

@onready var fps_label = $Control/fps_label

func _process(delta: float) -> void:
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func get_random_pitch() -> float:
	return randf_range(0.9, 1.1)

func click() -> void:
	$Button_click.play()

func enemy_spawn() -> void:
	$Enemy_spawn.play()

func ball_spawn() -> void:
	$Ball_spawn.pitch_scale = get_random_pitch()
	$Ball_spawn.play()

func enemy_move() -> void:
	$Enemy_move.play()
	await get_tree().create_timer(1).timeout
	$Enemy_move.stop()
