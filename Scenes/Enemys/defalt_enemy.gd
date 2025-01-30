extends StaticBody2D

var hp_enemy = randi() % 4 * 100 + 200
var player_damage = 100

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
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 0.15)
	await get_tree().create_timer(0.15)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.15)
	await get_tree().create_timer(0.3).timeout
	deal_damage(damage_ball)

func enemy():
	pass
