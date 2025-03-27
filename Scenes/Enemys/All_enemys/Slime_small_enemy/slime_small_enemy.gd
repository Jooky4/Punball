extends "res://Scenes/Enemys/All_enemys/Defalt_enemy/defalt_enemy.gd"

func small_slime() -> void:
	pass

func set_alive(_alive) -> void:
	alive = _alive
	if _alive == true:
		LevelManager.check_traps()
