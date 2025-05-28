extends Node2D

var MUSIC_PULL = [preload("res://Resources/Music/music.ogg")]

@onready var sounds: Dictionary = {
	"ricochet": $Ricochet_sound,
	"hit_enemy": $Hit_enemy_sound,
	"hit_enemy_shuriken": $Hit_enemy_shuriken,
	"hit_enemy_bomb": $Hit_enemy_bomb,
	"hit_enemy_fireball": $Hit_enemy_fireball,
	"hit_enemy_char3ball": $Hit_enemy_char3ball,
	"hit_enemy_laserball": $Hit_enemy_laserball,
	"hit_enemy_killerball": $Hit_enemy_killerball,
	"hit_enemy_freezingball": $Hit_enemy_freezingball,
	"hit_enemy_drillingball": $Hit_enemy_drillingball,
	"hit_enemy_small_crumbling_ball": $Hit_enemy_small_crumbling_ball,
	"hit_enemy_crumbling_ball": $Hit_enemy_crumbling_ball
}

func _ready():
	get_viewport().connect("focus_entered", _on_focus_entered)
	get_viewport().connect("focus_exited", _on_focus_exited)

func _on_focus_entered():
	if get_tree().current_scene.has_method("revavil_player"):
		YandexSDK.gameplay_started()
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func _on_focus_exited():
	YandexSDK.gameplay_stopped()
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

func music_start() -> void:
	if $Music.playing != true:
		$Music.stream = MUSIC_PULL[randi() % MUSIC_PULL.size()]
		$Music.playing = true


func get_random_pitch() -> float:
	#return randf_range(-0.1, 0.1) убрал рандом питча пока что
	return 0

func click() -> void:
	$Button_click.play()

func enemy_spawn() -> void:
	$Enemy_spawn.play()

func ball_spawn() -> void:
	$Ball_spawn.pitch_scale += get_random_pitch()
	$Ball_spawn.play()

func enemy_move() -> void:
	$Enemy_move.play()
	await get_tree().create_timer(1).timeout
	$Enemy_move.stop()

func lightning_sound() -> void:
	$Lightning.stop()
	$Lightning.pitch_scale += get_random_pitch()
	$Lightning.play()

func bomb_sound() -> void:
	$Bomb_explosion.stop()
	$Bomb_explosion.pitch_scale += get_random_pitch()
	$Bomb_explosion.play()

func freezing_bomb_sound() -> void:
	$Bomb_explosion_var_2.stop()
	$Bomb_explosion_var_2.pitch_scale += get_random_pitch()
	$Bomb_explosion_var_2.play()

func freezing_combo_sound() -> void:
	$Freezing_combo_sound.pitch_scale += get_random_pitch()
	$Freezing_combo_sound.play()

func fire_combo_sound() -> void:
	$Fire_combo_sound.pitch_scale += get_random_pitch()
	$Fire_combo_sound.play()

func liser_sound() -> void:
	$Laser_sound.pitch_scale += get_random_pitch()
	$Laser_sound.play()

func thorns_combo_sound() -> void:
	$Thorns.pitch_scale += get_random_pitch()
	$Thorns.play()

func health_sound() -> void:
	$Health_sound.pitch_scale += get_random_pitch()
	$Health_sound.play()

func _on_music_finished() -> void:
	$Music.stream = MUSIC_PULL[randi() % MUSIC_PULL.size()]
	$Music.playing = true

func bomb_ball_hit_sound() -> void:
	$Bomb_explosion_var_2.stop()
	$Bomb_ball_hit_sound.pitch_scale += get_random_pitch()
	$Bomb_ball_hit_sound.play()

func cumulative_ball_hit_sound() -> void:
	$Cumulative_ball_hit_sound.pitch_scale += get_random_pitch()
	$Cumulative_ball_hit_sound.play()


func bye_talant_sound() -> void:
	$Bye_talant.play()


func play_sound(name: String) -> void:
	#if OS.is_debug_build():
		#prints("AM.play_sound(%s)" % name)

	if sounds.has(name):
		var sound = sounds[name]
		sound.play()
	else:
		prints("no sound '%s' founded" % name)
