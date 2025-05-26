extends Control

# оригинальный код, запускающийся в каждом кадре
"""
if LevelManager.combo_count > combo_count:
	combo_count_label.visible = true
	combo_count_label.text = str(LevelManager.combo_count)
	combo_count_label.scale = Vector2(1.5, 1.5)
	combo_count = LevelManager.combo_count
else:
	if combo_count_label.scale > Vector2(1, 1):
		combo_count_label.scale -= Vector2(0.05, 0.05)
"""

@onready var count_label: Label = $CountLabel


func _ready() -> void:
	LevelManager.combo_count_updated.connect(_on_levelmanager_update_combo)


func _on_levelmanager_update_combo(value: int) -> void:
	_on_update_label(value)


func _on_update_label(value: int) -> void:
	visible = value > 0

	var _t = create_tween()
	_t.tween_property(count_label, "scale", Vector2(1, 1), 0.01)
	_t.play()
	_t.tween_property(count_label, "scale", Vector2(1.3, 1.3), 0.15)
	count_label.text = str(value)
	_t.play()

	_t.tween_property(count_label, "scale", Vector2(1, 1), 0.05)
	_t.play()
