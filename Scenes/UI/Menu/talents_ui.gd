extends Control

@onready var level_scroll = $Lvl_ScrollContainer
@onready var skill_scroll = $Scill_ScrollContainer

func _ready() -> void:
	level_scroll.scroll_vertical = 10000
	skill_scroll.scroll_vertical = 10000

func _process(delta):
	if level_scroll.scroll_vertical != skill_scroll.scroll_vertical:
		skill_scroll.scroll_vertical = level_scroll.scroll_vertical
