extends Control

@onready var level_label = $Line/Level_texture_box/Label_Lvl
@onready var line = $Line

func update_lvl(lvl: int) -> void:
	level_label.text = str(lvl)

func set_visible_conteiner(visible_: bool) -> void:
	line.visible = visible_
