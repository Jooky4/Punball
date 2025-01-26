extends StaticBody2D

var hp_boss = 100
@onready var hp_boss_label = $Hp_boss_label
var length_boss_path = 300
var boss_speed = Vector2(100, 0)

func deal_damage() -> void:
	hp_boss -= 50
	if hp_boss <= 0:
		queue_free()
	else:
		hp_boss_label.text = str(hp_boss)

func _process(delta: float) -> void:
	pass
	#position += boss_speed * delta
	#length_boss_path -= abs(boss_speed.x) * delta
	#if length_boss_path <= 0:
		#length_boss_path = 300
		#boss_speed *= -1

func enemy():
	pass
