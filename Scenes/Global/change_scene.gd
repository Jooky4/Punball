extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animetionplayer = $AnimationPlayer

func _ready():
	color_rect.visible = false

func black_screen() -> void:
	color_rect.visible = true
	animetionplayer.play("Black_screen")

func normal_screen() -> void:
	animetionplayer.play("Normal_screen")
