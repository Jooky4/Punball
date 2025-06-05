@tool
extends Node2D


@export var backgrounds: Array[Texture2D]
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	if backgrounds.size():
		sprite_2d.texture = backgrounds[0]


func set_background(value: int) -> void:
	var image = Image.new()
	var _bg = load(LevelBackgroundData.get_level_bg_path(value))
	sprite_2d.texture = _bg
