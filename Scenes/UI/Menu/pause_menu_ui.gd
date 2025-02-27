extends Control

func _ready() -> void:
	self.visible = false

func _on_continue_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	self.visible = false
