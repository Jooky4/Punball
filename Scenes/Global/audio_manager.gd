extends Node2D

var MUSIC_PULL = [
	#preload("res://Resources/Music/music.ogg"), # volume -27 db
	preload("res://Resources/Music/music_cut_58sec.mp3")
]


var sfx_config = {
	"ball_spawn": {
		"path": "res://Resources/Sounds/спавн_шариков.mp3",
		"volume": -10,
		"pitch": 1,
		"sound": null
	},
	"ricochet": {
		"path": "res://Resources/Sounds/спавн_шариков.mp3",
		"volume": -14,
		"pitch": 1,
		"sound": null
	},
	"hit_enemy": {
		"path": "res://Resources/Sounds/обычный.mp3",
		"volume": -12,
		"pitch": 1,
		"sound": null
	},
	"hit_enemy_shuriken": {
		"path": "res://Resources/Sounds/сюрикен.mp3",
		"volume": -12,
		"pitch": 1,
		"sound": null
	},
	"hit_enemy_bomb": {
		"path": "res://Resources/Sounds/взрыв_бомба.mp3",
		"volume": 0,
		"pitch": 1.5,
		"sound": null
	},
	"hit_enemy_fireball": {
		"path": "res://Resources/Sounds/огненный_шар.mp3",
		"volume": -7,
		"pitch": 1.4,
		"sound": null
	},
	"hit_enemy_char3ball": {
		"path": "res://Resources/Sounds/рассыпающийся_шар.mp3",
		"volume": -10,
		"pitch": 0.9,
		"sound": null
	},
	"hit_enemy_laserball": {
		"path": "res://Resources/Sounds/лазер_шар.mp3",
		"volume": -10,
		"pitch": 1.3,
		"sound": null
	},
	"hit_enemy_killerball": {
		"path": "res://Resources/Sounds/убийца.mp3",
		"volume": -5,
		"pitch": 1,
		"sound": null
	},
	"hit_enemy_freezingball": {
		"path": "res://Resources/Sounds/заморозка_шар.mp3",
		"volume": -10,
		"pitch": 1.5,
		"sound": null
	},
	"hit_enemy_drillingball": {
		"path": "res://Resources/Sounds/бурящий.mp3",
		"volume": -17,
		"pitch": 1.2,
		"sound": null
	},
	"hit_enemy_small_crumbling_ball": {
		"path": "res://Resources/Sounds/рассыпающийся_шар.mp3",
		"volume": -7,
		"pitch": 1,
		"sound": null
	},
	"hit_enemy_crumbling_ball": {
		"path": "res://Resources/Sounds/рассыпающийся_шар.mp3",
		"volume": -7,
		"pitch": 1,
		"sound": null
	},
	"cumulative_ball_hit_sound": {
		"path": "res://Resources/Sounds/кумулятивный2.ogg",
		"volume": -7,
		"pitch": 1.2,
		"sound": null
	},
	"buy_talant": {
		"path": "res://Resources/Sounds/покупка_таланта.mp3",
		"volume": -4,
		"pitch": 1,
		"sound": null
	},
	"bomb_ball_hit_sound": {
		"path": "res://Resources/Sounds/взрыв_бомба.mp3",
		"volume": -4,
		"pitch": 1.2,
		"sound": null
	},
	"heal_sound": {
		"path": "res://Resources/Sounds/звукОЗ.mp3",
		"volume": -17,
		"pitch": 1.5,
		"sound": null
	},
	"click": {
		"path": "res://Resources/Sounds/клик.mp3",
		"volume": 0,
		"pitch": 1,
		"sound": null
	},
	"enemy_spawn": {
		"path": "res://Resources/Sounds/спавн врагов.mp3",
		"volume": -14,
		"pitch": 1,
		"sound": null
	},
	"enemy_move": {
		"path": "res://Resources/Sounds/шаги.mp3",
		"volume": 0,
		"pitch": 1,
		"sound": null
	},
	"lightning": {
		"path": "res://Resources/Sounds/молния_2.ogg",
		"volume": -14,
		"pitch": 1.1,
		"sound": null
	},
	"bomb_explosion": {
		"path": "res://Resources/Sounds/взрыв_бомба.mp3",
		"volume": -4,
		"pitch": 1.4,
		"sound": null
	},
	"bomb_explosion2": {
		"path": "res://Resources/Sounds/взрыв_бомба_3.ogg",
		"volume": -4,
		"pitch": 1.4,
		"sound": null
	},
	"trap": {
		"path": "res://Resources/Sounds/ловушка.mp3",
		"volume": -10,
		"pitch": 1,
		"sound": null
	},
	"rocket": {
		"path": "res://Resources/Sounds/ракета.mp3",
		"volume": 5,
		"pitch": 1,
		"sound": null
	},
	"rocket_start": {
		"path": "res://Resources/Sounds/ракета_старт.ogg",
		"volume": -15,
		"pitch": 1,
		"sound": null
	},
	"rocket_end": {
		"path": "res://Resources/Sounds/обычный.mp3",
		"volume": -12,
		"pitch": 1,
		"sound": null
	},
	"laser": {
		"path": "res://Resources/Sounds/лазер_шар.mp3",
		"volume": -5,
		"pitch": 1.2,
		"sound": null
	},
	"thorns": {
		"path": "res://Resources/Sounds/шипы.mp3",
		"volume": -10,
		"pitch": 1,
		"sound": null
	},
	"fire_combo": {
		"path": "res://Resources/Sounds/огненный_шар.mp3",
		"volume": 0,
		"pitch": 1,
		"sound": null
	},
	"freezing_combo": {
		"path": "res://Resources/Sounds/заморозка_шар.mp3",
		"volume": 0,
		"pitch": 1,
		"sound": null
	},
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
	play_sound("click")


func enemy_spawn() -> void:
	play_sound("enemy_spawn")


func enemy_move() -> void:
	#$Enemy_move.play()
	play_sound("enemy_move")
	await get_tree().create_timer(1).timeout
	#$Enemy_move.stop()
	stop_sound("enemy_move")


func lightning_sound() -> void:
	stop_sound("lightning")
	#pitch_scale += get_random_pitch()
	play_sound("lightning")


func bomb_sound() -> void:
	stop_sound("bomb_explosion")
	#$Bomb_explosion.pitch_scale += get_random_pitch()
	play_sound("bomb_explosion")


func freezing_bomb_sound() -> void:
	stop_sound("bomb_explosion2")
	#$Bomb_explosion_var_2.pitch_scale += get_random_pitch()
	play_sound("bomb_explosion2")


func freezing_combo_sound() -> void:
	#_sound.pitch_scale += get_random_pitch()
	play_sound("freezing_combo")


func fire_combo_sound() -> void:
	#_sound.pitch_scale += get_random_pitch()
	play_sound("fire_combo")


func liser_sound() -> void:
	#_sound.pitch_scale += get_random_pitch()
	play_sound("laser")


func thorns_combo_sound() -> void:
	#_sound.pitch_scale += get_random_pitch()
	play_sound("thorns")


func health_sound() -> void:
	play_sound("heal_sound")


func _on_music_finished() -> void:
	$Music.stream = MUSIC_PULL[randi() % MUSIC_PULL.size()]
	$Music.playing = true


func bomb_ball_hit_sound() -> void:
	stop_sound("bomb_explosion2")
	#$Bomb_explosion_var_2.stop()
	#$Bomb_ball_hit_sound.pitch_scale += get_random_pitch()
	#$Bomb_ball_hit_sound.play()
	play_sound("bomb_ball_hit_sound")


func bye_talant_sound() -> void:
	play_sound("buy_talant")


func stop_sound(name: String) -> void:
	if OS.is_debug_build():
		prints("AM.stop_sound(%s)" % name)

	if sfx_config.has(name) and sfx_config[name].sound:
		sfx_config[name].sound.stop()


func play_sound(name: String) -> void:
	if OS.is_debug_build():
		prints("AM.play_sound(%s)" % name)

	var sfx_c = sfx_config[name]

	if sfx_c.sound:
		sfx_c.sound.play()
	else:
		var asp = AudioStreamPlayer.new()
		add_child(asp)
		asp.stream = load(sfx_c.path)
		asp.volume_db = sfx_c.volume
		asp.pitch_scale = sfx_c.pitch
		sfx_c.sound = asp
		sfx_c.sound.play()
