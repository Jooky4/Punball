extends StaticBody2D

var bank_with_experience = preload("res://Scenes/Bonus/bank_with_experience.tscn")

@export var hp_enemy : float = 400#randi() % 4 * 100 + 200
@export var player_damage : int = 100
@export var start_scale_damage_label : float = 0.2
@export var end_scale_damage_label : float = 0.8
var alive = true
var freezen : bool = false

@onready var hp_enemy_label = $Hp_boss_label
@onready var hp_enemy_bar = $TextureProgressBar
@onready var label_enemy_damage = $Label_enemy_damage

func _ready() -> void:
	hp_enemy_bar.max_value = hp_enemy
	hp_enemy_bar.value = hp_enemy
	hp_enemy_label.text = str(hp_enemy)

func enemy() -> void:
	pass

func deal_damage(damage_ball, color_label) -> void:
	if alive:
		hp_enemy -= damage_ball
		create_label_damage(damage_ball, color_label)
		hp_enemy_label.text = str(hp_enemy)
		hp_enemy_bar.value = hp_enemy
	if hp_enemy <= 0 and alive:
		alive = false
		for i in self.get_children():
			if "Label" not in i.name:
				i.queue_free()
		var buff = bank_with_experience.instantiate()
		buff.position = self.global_position
		get_tree().current_scene.add_child(buff)
		await get_tree().create_timer(1.5).timeout
		queue_free()

func deal_bomb_damage(damage_ball, color_label) -> void:
	deal_damage(damage_ball, color_label)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 0.2)
	await get_tree().create_timer(0.2).timeout
	var tween1 = get_tree().create_tween()
	tween1.tween_property($Sprite2D, "modulate", Color.WHITE, 0.3)

func deal_freezing_damage(damage_ball, color_label) -> void:
	freezen = true
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.DODGER_BLUE, 0.15)
	deal_damage(damage_ball, color_label)

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


func create_label_damage(damage_ball, color_label) -> void:
	var label = label_enemy_damage.duplicate()
	label.text = "-" + str(damage_ball)
	label.modulate = color_label
	label.scale = Vector2(start_scale_damage_label, start_scale_damage_label)
	label.visible = true
	$".".add_child(label)
	var tween = get_tree().create_tween()
	tween.tween_property(label, "position", Vector2(label.position.x + randi_range(-50, 50), label.position.y - randi_range(60, 75)), 0.3)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(label, "scale", Vector2(end_scale_damage_label, end_scale_damage_label), 0.4)
	
	await get_tree().create_timer(0.5).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(label, "modulate:a", 0, 0.35)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(label, "position", Vector2(label.position.x, label.position.y + 25) , 0.5)
	await get_tree().create_timer(0.35).timeout
	label.queue_free()
