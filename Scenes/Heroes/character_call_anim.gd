extends Node2D

@onready var animation = $AnimationPlayer

func idle() -> void:
	animation.play("Idle")

func alive() -> void:
	animation.play("Alive")

func attack() -> void:
	animation.play("Attack")

func damage() -> void:
	animation.play("Damage")

func death() -> void:
	animation.play("Death")

func move_left() -> void:
	animation.play("MoveLeft")

func move_right() -> void:
	animation.play("MoveRight")

func pause() -> void:
	animation.pause()

func not_pause() -> void:
	animation.play("Attack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack" or anim_name == "Spawn":
		idle()
