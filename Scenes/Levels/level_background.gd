@tool
extends Node2D


@export var backgrounds: Array[Texture2D]
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	if backgrounds.size():
		sprite_2d.texture = backgrounds[0]


func set_background(value: int) -> void:
	sprite_2d.texture = backgrounds[value]
