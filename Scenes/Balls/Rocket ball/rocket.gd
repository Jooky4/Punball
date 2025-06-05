extends Node2D

var speed : float = 250
var start_position
var end_position
var arc_height = -150
var min_duration : float = 0.4  # Минимальное время полета (в секундах) ДОБАВИЛ ДИМА
var max_duration : float = 0.6  # Максимальное время полета (в секундах) ДОБАВИЛ ДИМА
var rocket_damage : int = 300

@onready var end_sound = $End_sound

func _ready() -> void:
	AudioManager.play_sound("rocket_start")
	#start_sound.pitch_scale += AudioManager.get_random_pitch()
	#start_sound.play()

func go(enemy, start_pos) -> void:
	if enemy != null:
		start_position = start_pos
		end_position = enemy.global_position
		rotation_degrees = 90 + rad_to_deg(position.angle_to_point((end_position - start_position).normalized() * 10000))
		var distance = start_pos.distance_to(enemy.global_position)

		var duration = distance / speed # Рассчитываем время полета ДОБАВИЛ ДИМА
		duration = clamp(duration, min_duration, max_duration)  # Устанавливаем минимальное и максимальное время ДОБАВИЛ ДИМА

		var tween = create_tween()
		tween.tween_method(_move_along_arc, 0.0, 1.0, duration)
		tween.set_trans(Tween.TRANS_EXPO)
		await tween.finished
		if enemy != null:
			enemy.deal_damage(rocket_damage, ElementsManager.color_elements["NUCLEAR"])

			# TODO: перенести в AudioManager.play_sound("rocket_end")
			end_sound.pitch_scale += AudioManager.get_random_pitch()
			end_sound.play()
			self.visible = false
	else:
		queue_free()

func _move_along_arc(t: float):
	rotation_degrees = 90 + rad_to_deg(position.angle_to_point((end_position - self.global_position).normalized() * 10000))
	var x = lerp(start_position.x, end_position.x, t)
	var y = lerp(start_position.y, end_position.y, t) + arc_height * sin(t * PI)
	self.global_position = Vector2(x, y)

func _on_end_sound_finished() -> void:
	queue_free()
