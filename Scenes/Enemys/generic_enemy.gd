class_name GenericEnemy extends StaticBody2D

@export var hp_enemy: float = 400
@export var player_damage: int = 100

# TODO: перенести в префаб label_enemy_damage.tscn
@export var start_scale_damage_label: float = 0.2
@export var end_scale_damage_label: float = 0.8

var alive: bool = true
var on_last_line: bool = false
var freezen: bool = false
var on_fire: bool = false
var poisoned: bool = false
var move_on_this_wave: bool = false
var max_hp_enemy: float

signal died


func is_boss() -> bool:
	return false


func is_alive() -> bool:
	return alive


func die() -> void:
	# Применяем эффект после смерти врага
	LevelManager.enemy_died(self)
	died.emit()
