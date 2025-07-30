extends CanvasLayer

@export var game_scene: PackedScene

# TODO: заменить имена на enum?
var scene_aliases: Dictionary = {
	"game": "res://Scenes/Levels/first_level.tscn",
	"menu": "res://Scenes/UI/Menu/menu.tscn",
	"win": "res://Scenes/UI/Win_Lose_UI/win_lose_UI.tscn",
	"game_over": "res://Scenes/UI/Win_Lose_UI/win_lose_UI.tscn"
}

@onready var color_rect = $ColorRect
@onready var animetionplayer = $AnimationPlayer
@onready var debug_label: Label = $DebugLabel
@onready var fps_indicator: Label = $FpsIndicator

@onready var canvas = JavaScriptBridge.get_interface("document").getElementById("canvas")

func _ready():
	if Constants.SHOW_FPS:
		fps_indicator.show()
	else:
		fps_indicator.hide()

	color_rect.visible = false


func black_screen() -> void:
	color_rect.visible = true
	animetionplayer.play("Black_screen")


func to(scene_name: String) -> void:
	if scene_aliases.has(scene_name):
		var _scene = scene_aliases[scene_name]
		var _status = get_tree().change_scene_to_file(_scene)

		if _status == OK:
			normal_screen()
		elif _status == ERR_CANT_OPEN:
			debug_label.text = "ERR_CANT_OPEN: %s" % _scene
		elif _status == ERR_CANT_CREATE:
			debug_label.text = "ERR_CANT_CREATE: %s" % _scene


func normal_screen() -> void:
	animetionplayer.play("Normal_screen")
