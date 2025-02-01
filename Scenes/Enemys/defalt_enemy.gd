extends StaticBody2D

@export var hp_enemy : int = 400#randi() % 4 * 100 + 200
@export var player_damage : int = 100
var freezen : bool = false

@onready var hp_enemy_label = $Hp_boss_label
@onready var hp_enemy_bar = $TextureProgressBar

func _ready() -> void:
	hp_enemy_bar.max_value = hp_enemy
	hp_enemy_bar.value = hp_enemy
	hp_enemy_label.text = str(hp_enemy)

func deal_damage(damage_ball) -> void:
	hp_enemy -= damage_ball
	if hp_enemy <= 0:
		queue_free()
	else:
		hp_enemy_label.text = str(hp_enemy)
		hp_enemy_bar.value = hp_enemy

func deal_bomb_damage(damage_ball) -> void:
	deal_damage(damage_ball)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 0.15)
	await get_tree().create_timer(0.15)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.15)
	await get_tree().create_timer(0.3).timeout

func deal_freezing_damage(damage_ball) -> void:
	freezen = true
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.DODGER_BLUE, 0.15)
	deal_damage(damage_ball)

func delete_freezing() -> void:
	freezen = false
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.01)

func moving(direction_object) -> void:
	if direction_object != "":
		var tween = get_tree().create_tween()
		if direction_object == "forward":
			tween.tween_property($".", "position", Vector2(0, 103) + self.position, 1)
		elif direction_object == "left":
			tween.tween_property($".", "position", Vector2(-103, 0) + self.position, 1)
		elif direction_object == "right":
			tween.tween_property($".", "position", Vector2(103, 0) + self.position, 1)

func enemy() -> void:
	pass
