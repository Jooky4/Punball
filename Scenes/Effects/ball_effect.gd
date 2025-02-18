extends Node2D

func _ready() -> void:
	for i in self.get_children():
		i.emitting = true
	await get_tree().create_timer(2).timeout
	queue_free()
