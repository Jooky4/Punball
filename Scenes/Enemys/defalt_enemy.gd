extends StaticBody2D

var bank_with_experience = preload("res://Scenes/Bonus/bank_with_experience.tscn")
var LABEL_DAMAGE = preload("res://Scenes/Enemys/label_enemy_damage.tscn")

@export var hp_enemy : float = 400#randi() % 4 * 100 + 200
@export var player_damage : int = 100
@export var start_scale_damage_label : float = 0.2
@export var end_scale_damage_label : float = 0.8
var alive = true
var freezen : bool = false

@onready var hp_enemy_label = $Hp_boss_label
@onready var hp_enemy_bar = $TextureProgressBar
@onready var animation_enemy = $AnimationPlayer

func _ready() -> void:
	animation_enemy.play("Spawn")
	hp_enemy_bar.max_value = hp_enemy
	hp_enemy_bar.value = hp_enemy
	hp_enemy_label.text = str(hp_enemy)

func enemy() -> void:
	pass

func deal_damage(damage_ball, color_label) -> void:
	animation_enemy.stop()
	animation_enemy.play("Damage")
	hp_enemy -= damage_ball
	create_label_damage(damage_ball, color_label)
	hp_enemy_label.text = str(hp_enemy)
	hp_enemy_bar.value = hp_enemy
	if hp_enemy <= 0 and alive:
		var buff = bank_with_experience.instantiate()
		buff.position = self.global_position
		get_tree().current_scene.add_child(buff)
		queue_free()

func deal_bomb_damage(damage_ball, color_label) -> void:
	deal_damage(damage_ball, color_label)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite_enemy, "modulate", Color.RED, 0.2)
	await get_tree().create_timer(0.2).timeout
	var tween1 = get_tree().create_tween()
	tween1.tween_property($Sprite_enemy, "modulate", Color.WHITE, 0.3)

func deal_freezing_damage(damage_ball, color_label) -> void:
	deal_damage(damage_ball, color_label)
	freezen = true
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite_enemy, "modulate", Color.DODGER_BLUE, 0.15)

func delete_freezing() -> void:
	freezen = false
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite_enemy, "modulate", Color.WHITE, 0.01)

func moving(direction_object) -> void:
	animation_enemy.play("Move")
	if direction_object != "":
		var tween = get_tree().create_tween()
		if direction_object == "forward":
			tween.tween_property($".", "position", Vector2(0, 103) + self.position, 1)
		elif direction_object == "left":
			tween.tween_property($".", "position", Vector2(-103, 0) + self.position, 1)
		elif direction_object == "right":
			tween.tween_property($".", "position", Vector2(103, 0) + self.position, 1)
	await get_tree().create_timer(1).timeout
	animation_enemy.play("Idle")

func create_label_damage(damage_ball, color_label) -> void:
	var label = LABEL_DAMAGE.instantiate()
	label.global_position = self.global_position
	label.text = "-" + str(damage_ball)
	label.modulate = color_label
	label.scale = Vector2(start_scale_damage_label, start_scale_damage_label)
	label.visible = true
	get_tree().current_scene.add_child(label)
