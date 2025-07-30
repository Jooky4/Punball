extends Node


func _ready() -> void:
	if GP.is_inited:
		go_to_main_scene(true)
		return

	GP.inited.connect(go_to_main_scene)


func go_to_main_scene(success: bool) -> void:
	GP.Player.player_ready.connect(PlayerIndicatorsManager._on_player_ready)
	ChangeScene.to("menu")
