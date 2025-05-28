extends Control

@export var skills_tileset: TileSet

var regular = ["Шар-заморозка","Лед: комбо", "Ядерная: комбо", "Прибавка к восстановлению","Прибавка ОЗ", "Усиление обычного шара"]
var rare = ["Огненный шар", "Шар-бомба", "Бомба-заморозка", "Молния: комбо", "Лазер: комбо", "Огонь: комбо", "Кумулятивный шар", "Шар удара в спину", "Шар убийца", "Технология: комбо с тыла", "Технология: комбо с фронта", "Усиление особого шара", "Усиление атаки", "Комбо: скидка", "Суперначало"]
var epic = ["Шар молний", "Повелитель льда", "Повелитель огня", "Рассыпающийся шар","Вертикальный лазерный шар","Горизонтальный лазерный шар","Повелитель лазера", "Шар ракета","Повелитель атома","Бурящий шар", "Ловушка", "Холод смерти", "Повелитель молний"]
var legendary = ["Молния смерти", "Бомба смерти", "Лазер смерти", "Ракета смерти", "Повелитель технологий", "Оживление",  "Последний рывок"]

var regular_ramk = preload("res://Texture/UI/Pause_UI/обычная.png")
var rare_ramk = preload("res://Texture/UI/Pause_UI/редкая.png")
var epic_ramk = preload("res://Texture/UI/Pause_UI/эпическая.png")
var legendary_ramk = preload("res://Texture/UI/Pause_UI/легенда.png")


var texture_skill: Dictionary = { # Название : координаты тайла в сетке TileSet
	"Шар-заморозка": Vector2i(2, 0),
	"Усиление обычного шара": Vector2i(2, 5),
	"Рассыпающийся шар": Vector2i(3, 4),
	"Шар-бомба": Vector2i(5, 5),
	"Усиление особого шара": Vector2i(3, 5),
	"Прибавка ОЗ": Vector2i(0, 4),
	"Шар молний": Vector2i(3, 0),
	"Бомба-заморозка": Vector2i(0, 1),
	"Огненный шар": Vector2i(4, 2),
	"Усиление атаки": Vector2i(1, 5),
	"Молния смерти": Vector2i(3, 2),
	"Холод смерти": Vector2i(4, 5),
	"Бомба смерти": Vector2i(1, 1),
	"Повелитель молний": Vector2i(2, 3),
	"Повелитель льда": Vector2i(5, 3),
	"Повелитель огня": Vector2i(3, 3),
	"Молния: комбо": Vector2i(2, 2),
	"Лед: комбо": Vector2i(3, 1),
	"Огонь: комбо": Vector2i(5, 2),
	"Вертикальный лазерный шар": Vector2i(0, 0),
	"Горизонтальный лазерный шар": Vector2i(1, 0),
	"Лазер смерти": Vector2i(0, 2),
	"Повелитель лазера": Vector2i(1, 3),
	"Лазер: комбо": Vector2i(6, 1),
	"Суперначало": Vector2i(5, 4),
	"Последний рывок": Vector2i(6, 3),
	"Шар ракета": Vector2i(4, 0),
	"Кумулятивный шар": Vector2i(5, 1),
	"Ракета смерти": Vector2i(2, 4),
	"Повелитель атома": Vector2i(0, 3),
	"Ядерная: комбо": Vector2i(4, 1),
	"Шар удара в спину": Vector2i(6, 0),  # Исправлено с 6, 00 на 6, 0
	"Шар убийца": Vector2i(5, 0),
	"Бурящий шар": Vector2i(2, 1),
	"Ловушка": Vector2i(1, 2),
	"Повелитель технологий": Vector2i(4, 3),
	"Технология: комбо с тыла": Vector2i(6, 4),
	"Технология: комбо с фронта": Vector2i(0, 5),
	"Комбо: скидка": Vector2i(4, 4),
	"Прибавка к восстановлению": Vector2i(1, 4),
	"Оживление": Vector2i(6, 2),
}


func _ready() -> void:
	self.visible = false


func _on_continue_pressed() -> void:
	AudioManager.click()
	Engine.time_scale = 1
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	self.visible = false
	YandexSDK.gameplay_started()


func update_texture_skill() -> void:
	check_volume()
	var skills_box : Array = $Player_skills.get_children()
	for i in range(LevelManager.player_skills.size()):
		var skill = LevelManager.player_skills[i]
		skills_box[i].visible = true
		if skill in regular:
			skills_box[i].texture = regular_ramk
		elif skill in rare:
			skills_box[i].texture = rare_ramk
		elif skill in epic:
			skills_box[i].texture = epic_ramk
		elif skill in legendary:
			skills_box[i].texture = legendary_ramk

		var grid_pos = texture_skill[skill]
		var skill_texture = Utils.get_tileset_atlas_texture(
			skills_tileset.get_source(0),
			grid_pos
		)
		skills_box[i].get_child(0).texture = skill_texture


func _on_home_pressed() -> void:
	AudioManager.click()
	if PlayerIndicatorsManager.GAMEPLAY_TUTORIL == 0 and WaveGeneration.current_location == 1:
		Engine.time_scale = 1
		PlayerIndicatorsManager.GAMEPLAY_TUTORIL = 1
		await get_tree().create_timer(0.1).timeout
		PlayerIndicatorsManager.update_player_date_on_server()

		ChangeScene.to("menu")
	else:
		ChangeScene.to("menu")


func check_volume() -> void:
	if AudioServer.get_bus_volume_db(0) == -80:
		$Off_volume.button_pressed = true
		$Off_volume
	elif AudioServer.get_bus_volume_db(0) == 0:
		$Off_volume.button_pressed = false


func _on_off_volume_toggled(toggled_on: bool) -> void:
	if AudioServer.get_bus_volume_db(0) == -80:
		AudioServer.set_bus_volume_db(0, 0)
		AudioManager.click()
	elif AudioServer.get_bus_volume_db(0) == 0:
		AudioServer.set_bus_volume_db(0, -80)
