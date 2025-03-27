extends Camera2D

var shake_amount = 0.0

func _ready():
	set_process(true)

func _process(delta):
	if shake_amount > 0:
		shake_amount = max(shake_amount - delta * 2, 0)
		offset = Vector2(randf_range(-12, 12) * shake_amount,0)

func small_shake(amount):
	shake_amount = amount
