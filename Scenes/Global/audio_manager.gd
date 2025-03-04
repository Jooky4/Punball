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

func lightning_sound() -> void:
	$Lightning.pitch_scale = get_random_pitch()
	$Lightning.play()

func bomb_sound() -> void:
	$Bomb_explosion.pitch_scale = get_random_pitch()
	$Bomb_explosion.play()

func freezing_bomb_sound() -> void:
	$Bomb_explosion_var_2.pitch_scale = get_random_pitch()
	$Bomb_explosion_var_2.play()

func freezing_combo_sound() -> void:
	$Freezing_combo_sound.pitch_scale = get_random_pitch()
	$Freezing_combo_sound.play()

func fire_combo_sound() -> void:
	$Fire_combo_sound.pitch_scale = get_random_pitch()
	$Fire_combo_sound.play()

func liser_sound() -> void:
	$Laser_sound.pitch_scale = get_random_pitch()
	$Laser_sound.play()

func thorns_combo_sound() -> void:
	$Thorns.pitch_scale = get_random_pitch()
	$Thorns.play()
