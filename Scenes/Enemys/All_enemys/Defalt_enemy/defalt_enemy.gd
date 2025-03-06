extends StaticBody2D

var BANK_WITH_EXPERIENCE = preload("res://Scenes/Bonus/bank_with_experience.tscn")
var RESTORE_HEALTH = preload("res://Scenes/Bonus/restore_health.tscn")
var LABEL_DAMAGE = preload("res://Scenes/Enemys/Dops/label_enemy_damage.tscn")
var DEATH_EFFECT= preload("res://Scenes/Enemys/Dops/death_effect.tscn")

@export var hp_enemy : float = 400
@export var player_damage : int = 100
@export var start_scale_damage_label : float = 0.2
@export var end_scale_damage_label : float = 0.8
var alive = true
var on_last_line = false
var freezen : bool = false
var on_fire : bool = false
var poisoned : bool = false
var move_on_this_wave : bool = false
var max_hp_enemy : float

@onready var hp_enemy_label = $Hp_boss_label
@onready var hp_enemy_bar = $TextureProgressBar
@onready var animation_enemy = $AnimationPlayer
@onready var fire_effect = $Fire_effect
@onready var freezen_sprite = $Sprite_enemy/freezen_sprite
@onready var collision_shape = $CollisionShape2D
@onready var hit_sound = $Hit_sound
@onready var death_sound = $Death_sound

func _ready() -> void:
	max_hp_enemy = hp_enemy
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("Spawn")
	hp_enemy_bar.max_value = max_hp_enemy
	hp_enemy_bar.value = hp_enemy
	if hp_enemy>=10000:
		hp_enemy_label.text = str(hp_enemy/1000) + "K"
	else:
		hp_enemy_label.text = str(hp_enemy)
	if !self.has_method("boss"):
		self.z_index = 2

func enemy() -> void:
	pass

func deal_damage(damage_ball, color_label, killer_ball : bool = false) -> void:
	if alive:
		if self.has_method("shiield_enemy"): # ЕСЛИ ЩИТОНОСЕЦ ПРОВЕРКА ЧТО МЯЧ НЕ СПЕРЕДИ
			if !self.call("can_ball_deal_damage"):
				create_label_damage("БЛОК", ElementsManager.color_elements["NORMAL"])
				return

		hp_enemy -= damage_ball
		if hp_enemy <= 0 and alive:
			alive = false 
			die()
		if killer_ball:
			create_label_damage("УБИЙЦА", color_label)
		else:
			create_label_damage(damage_ball, color_label)

		if animation_enemy.current_animation == "Move":
			await animation_enemy.current_animation_changed
		elif animation_enemy.current_animation == "Spawn":
			await await animation_enemy.current_animation_changed

		if hp_enemy <= 0 and alive == false:
			hp_enemy_label.text = "0"
			hp_enemy_bar.value = 0
			hp_enemy_label.visible = false
			hp_enemy_bar.visible = false
			collision_shape.queue_free()
			if !self.has_method("boss"):
				var buff_bank_experience = BANK_WITH_EXPERIENCE.instantiate()
				buff_bank_experience.position = self.global_position + Vector2(randi() % 5 - 25, randi() % 5 - 25)
				get_tree().current_scene.add_child(buff_bank_experience)
				if randf() < 0.2:
					var buff_health = RESTORE_HEALTH.instantiate()
					buff_health.position = self.global_position + Vector2(randi() % 5 + 25, randi() % 5 + 25)
					get_tree().current_scene.add_child(buff_health)
			if animation_enemy:
				death_sound.pitch_scale = AudioManager.get_random_pitch()
				death_sound.play()
				animation_enemy.play("Death")
				var effect = DEATH_EFFECT.instantiate()
				effect.global_position = self.global_position
				get_tree().current_scene.add_child(effect)
			return

		if animation_enemy and alive: # УБРАТЬ ЭТУ СТРОЧКУ
			if animation_enemy.current_animation != "Move" and animation_enemy.current_animation != "Spawn":
				animation_enemy.play("Damage")
			else:
				await animation_enemy.animation_changed
				animation_enemy.play("Damage")
		if hp_enemy>=10000:
			if int(hp_enemy) % 10000 == 0:
				hp_enemy_label.text = str(hp_enemy / 1000) + "K"
			if int(hp_enemy) % 10000 != 0:
				hp_enemy_label.text = ("%.1f" % (hp_enemy / 1000)) + "K"
		else:
			hp_enemy_label.text = str(round(hp_enemy))
		hp_enemy_bar.value = hp_enemy

func deal_bomb_damage(damage_ball, color_label) -> void:
	if alive:
		if self.has_method("shiield_enemy"):  # ЕСЛИ ЩИТОНОСЕЦ ПРОВЕРКА ЧТО МЯЧ НЕ СПЕРЕДИ
			if !self.call("can_ball_deal_damage"):
				create_label_damage("БЛОК", ElementsManager.color_elements["NORMAL"])
				return

		deal_damage(damage_ball, color_label)

func deal_freezing_damage(damage_ball, color_label) -> void:
	if alive:
		if self.has_method("shiield_enemy"):  # ЕСЛИ ЩИТОНОСЕЦ ПРОВЕРКА ЧТО МЯЧ НЕ СПЕРЕДИ
			if !self.call("can_ball_deal_damage"):
				create_label_damage("БЛОК", ElementsManager.color_elements["NORMAL"])
				return

		deal_damage(damage_ball, color_label)
		if randf() < LevelManager.chance_of_freezing:
			freezen = true
			freezen_sprite.visible = true

func deal_fire_damage(damage_ball, color_label) -> void:
	if alive:
		if self.has_method("shiield_enemy"):  # ЕСЛИ ЩИТОНОСЕЦ ПРОВЕРКА ЧТО МЯЧ НЕ СПЕРЕДИ
			if !self.call("can_ball_deal_damage"):
				create_label_damage("БЛОК", ElementsManager.color_elements["NORMAL"])
				return

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
	if poisoned:
		deal_damage(200, ElementsManager.color_elements["POISON"])
		poisoned = false

func moving(direction_object) -> void:
	if alive and animation_enemy.current_animation != "Spawn":
		if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
			animation_enemy.play("Move")
		if direction_object != "":
			var tween = create_tween()
			if direction_object == "forward":
				tween.tween_property(self, "position", Vector2(0, 103) + self.position, 1).set_trans(Tween.TRANS_QUAD)
			elif direction_object == "left":
				tween.tween_property(self, "position", Vector2(-103, 0) + self.position, 1).set_trans(Tween.TRANS_QUAD)
			elif direction_object == "right":
				tween.tween_property(self, "position", Vector2(103, 0) + self.position, 1).set_trans(Tween.TRANS_QUAD)
		await get_tree().create_timer(1).timeout
		if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
			if on_last_line:
				animation_enemy.play("Preparation")
			else:
				animation_enemy.play("Idle")

func poisoning() -> void:
	poisoned = true

func create_label_damage(damage_ball, color_label) -> void:
	var label = LABEL_DAMAGE.instantiate()
	label.global_position = self.global_position
	if typeof(damage_ball) != 3 and typeof(damage_ball) != 2:
		label.text = str(damage_ball)
	elif color_label == ElementsManager.color_elements["HEAL"]:
		label.text = "+" + str(damage_ball)
	else:
		label.text = "-" + str(damage_ball)
	label.modulate = color_label
	label.scale = Vector2(start_scale_damage_label, start_scale_damage_label)
	get_tree().current_scene.add_child(label)
	label.show_label()

func enemy_on_last_line():
	on_last_line = true

func play_animation_hit_player():
	if animation_enemy and alive: # УБРАТЬ ЭТУ СТРОЧКУ
		animation_enemy.play("Hit")
		hit_sound.pitch_scale = AudioManager.get_random_pitch()
		hit_sound.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if animation_enemy: # УБРАТЬ ЭТУ СТРОЧКУ
		if anim_name == "Spawn":
			animation_enemy.play("Idle")
			if !self.has_method("boss"):
				self.z_index = 0
		elif anim_name == "Damage":
			if alive:
				if self.has_method("berserker_enemy"): 
					math_damage_player() # ПОСЛЕ УРОНА ЕСЛИ ЭТО БЕРСЕРК РАСЧИТЫВАЕИ УРОН ПО ИГРОКУ 
				if on_last_line:
					animation_enemy.play("Preparation")
				else:
					animation_enemy.play("Idle")
		elif anim_name == "Hit" and on_last_line and !self.has_method("boss"):
			self.queue_free()
		elif anim_name == "Death":
			LevelManager.enemy_died(self)
			self.visible = false
		else:
			if on_last_line:
				animation_enemy.play("Preparation")
			else:
				animation_enemy.play("Idle")

func heal_hp(hp_heal) -> void:
	hp_enemy += hp_heal
	if hp_enemy > max_hp_enemy:
		hp_enemy = max_hp_enemy
	hp_enemy_bar.value = hp_enemy
	if hp_enemy>=10000:
		if int(hp_enemy) % 10000 == 0:
			hp_enemy_label.text = str(hp_enemy / 1000) + "K"
		if int(hp_enemy) % 10000 != 0:
			hp_enemy_label.text = ("%.1f" % (hp_enemy / 1000)) + "K"
	else:
		hp_enemy_label.text = str(round(hp_enemy))
	create_label_damage(hp_heal, ElementsManager.color_elements["HEAL"])

func play_magic_spawn_anim():
	animation_enemy.stop()
	$Magic_spawn.pitch_scale = AudioManager.get_random_pitch()
	$Magic_spawn.play()
	animation_enemy.play("SpawnMagic")

func die() -> void:
	pass

func math_damage_player() -> void:
	pass

func _on_death_sound_finished() -> void:
	self.queue_free()
