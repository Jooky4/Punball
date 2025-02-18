extends Line2D

func _ready() -> void:
	await get_tree().create_timer(0.15).timeout
	queue_free()
