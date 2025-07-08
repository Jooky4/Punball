extends Node


func _ready() -> void:
	prints("main.gd ready")
	if GP.is_inited:
		go_to_main_scene(true)
		return

	GP.inited.connect(go_to_main_scene)


func go_to_main_scene(success: bool) -> void:
	ChangeScene.to("menu")
