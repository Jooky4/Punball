extends StaticBody2D

var bank_with_experience = preload("res://Scenes/Bonus/bank_with_experience.tscn")
var LABEL_DAMAGE = preload("res://Scenes/Enemys/Dops/label_enemy_damage.tscn")

@export var hp_enemy : float = 400
@export var player_damage : int = 100
@export var start_scale_damage_label : float = 0.2
@export var end_scale_damage_label : float = 0.8
var alive = true
var on_last_line = false
var freezen : bool = false
var on_fire : bool = false

@onready var hp_enemy_label = $Hp_boss_label
@onready var hp_enemy_bar = $TextureProgressBar
@onready var animation_enemy = $AnimationPlayer
@onready var fire_effect = $Fire_effect
@onready var freezen_sprite = $Sprite_enemy/freezen_sprite
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("Spawn")
	hp_enemy_bar.max_value = hp_enemy
	hp_enemy_bar.value = hp_enemy
	if hp_enemy>=1000:
		hp_enemy_label.text = str(hp_enemy/1000) + "K"
	else:
		hp_enemy_label.text = str(hp_enemy)

func enemy() -> void:
	pass

func deal_damage(damage_ball, color_label, killer_ball : bool = false) -> void:
	hp_enemy -= damage_ball
	if killer_ball:
		create_label_damage("УБИЙЦА", color_label)
	else:
		create_label_damage(damage_ball, color_label)
	if hp_enemy <= 0 and alive:
		collision_shape.queue_free()
		hp_enemy_label.text = "0"
		hp_enemy_bar.value = 0
		alive = false
		if animation_enemy:
			animation_enemy.stop()
			animation_enemy.play("Death")
			await animation_enemy.animation_finished
		LevelManager.enemy_died(self)
		var buff = bank_with_experience.instantiate()
		buff.position = self.global_position
		get_tree().current_scene.add_child(buff)
		queue_free()
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.stop()
		animation_enemy.play("Damage")
	if hp_enemy>=1000:
		hp_enemy_label.text = str(hp_enemy/1000) + "K"
	else:
		hp_enemy_label.text = str(round(hp_enemy))
	hp_enemy_bar.value = hp_enemy

func deal_bomb_damage(damage_ball, color_label) -> void:
	if alive:
		deal_damage(damage_ball, color_label)
		var tween = create_tween()
		tween.tween_property($Sprite_enemy, "modulate", Color.RED, 0.2)
		if freezen:
			tween.chain().tween_property($Sprite_enemy, "modulate", Color.DODGER_BLUE, 0.3)
		else:
			tween.chain().tween_property($Sprite_enemy, "modulate", Color.WHITE, 0.3)

func deal_freezing_damage(damage_ball, color_label) -> void:
	if alive:
		deal_damage(damage_ball, color_label)
		if randf() < LevelManager.chance_of_freezing:
			freezen = true
			freezen_sprite.visible = true

func deal_fire_damage(damage_ball, color_label) -> void:
	if alive:
		deal_damage(damage_ball, color_label)
		on_fire = true
		fire_effect.emitting = true

func delete_freezing_and_fire() -> void:
	if on_fire:
		if "Повелитель огня" in LevelManager.player_skills:
			LevelManager.ball_explosion(self, 200 * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])
		deal_fire_damage(200 * ElementsManager.fire_modifier, ElementsManager.color_elements["FIRE"])
		fire_effect.emitting = false
		on_fire = false
	if freezen:
		freezen = false
		freezen_sprite.visible = false

func moving(direction_object) -> void:
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("Move")
	if direction_object != "":
		var tween = create_tween()
		if direction_object == "forward":
			tween.tween_property(self, "position", Vector2(0, 103) + self.position, 1)
		elif direction_object == "left":
			tween.tween_property(self, "position", Vector2(-103, 0) + self.position, 1)
		elif direction_object == "right":
			tween.tween_property(self, "position", Vector2(103, 0) + self.position, 1)
	await get_tree().create_timer(1).timeout
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		if on_last_line:
			animation_enemy.play("Preparation")
		else:
			animation_enemy.play("Idle")

func create_label_damage(damage_ball, color_label) -> void:
	var label = LABEL_DAMAGE.instantiate()
	label.global_position = self.global_position
	if typeof(damage_ball) != 3 and typeof(damage_ball) != 2:
		label.text = str(damage_ball)
	else:
		label.text = "-" + str(damage_ball)
	label.modulate = color_label
	label.scale = Vector2(start_scale_damage_label, start_scale_damage_label)
	get_tree().current_scene.add_child(label)
	label.show_label()

func enemy_on_last_line():
	on_last_line = true

func play_animation_hit_player():
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("Hit")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		if anim_name == "Spawn":
			animation_enemy.play("Idle")
		if anim_name == "Damage":
			if on_last_line:
				animation_enemy.play("Preparation")
			else:
				animation_enemy.play("Idle")
		elif anim_name == "Hit" and on_last_line and !self.has_method("boss"):
			queue_free()
		else:
			if on_last_line:
				animation_enemy.play("Preparation")
			else:
				animation_enemy.play("Idle")
