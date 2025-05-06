extends Control

@export var skills_tileset: TileSet

@onready var skills_textures: VBoxContainer = $VScrollBar/Texture_skills
@onready var last_skill_texture: TextureRect = $VScrollBar/Texture_skills/TextureRect25

var discription = ""

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


# Функция для получения текстуры из атласа по координатам сетки
func _get_atlas_texture(grid_pos: Vector2i) -> AtlasTexture:
	var atlas_source: TileSetAtlasSource = skills_tileset.get_source(0)
	var atlas_texture = AtlasTexture.new()

	if atlas_source:
		atlas_texture.atlas = atlas_source.get_texture()
		atlas_texture.region = atlas_source.get_tile_texture_region(grid_pos)

	else:
		print("Ошибка: atlas_source не инициализирован!")

	return atlas_texture


func update_discription(new_discription) -> void:
	discription = new_discription


func show_rarity_window(skill, rarity : int) -> void:
	scroll_skill_animation(skill, rarity)
	$Discription_skill.visible = false
	$regular_window.visible = false
	$rare_window.visible = false
	$epic_window.visible = false
	$legendary_window.visible = false
	$AnimationPlayer.play("RESET")
	match rarity:
		1:
			$regular_window.visible = true
			$AnimationPlayer.play("regular_window")
		2:
			$regular_window.visible = true
			$rare_window.visible = true
			$AnimationPlayer.play("rare_window")
		3:
			$regular_window.visible = true
			$rare_window.visible = true
			$epic_window.visible = true
			$AnimationPlayer.play("epic_window")
		4:
			$regular_window.visible = true
			$rare_window.visible = true
			$epic_window.visible = true
			$legendary_window.visible = true
			$AnimationPlayer.play("legend_window")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Discription_skill.visible = true
	$Discription_skill.text = discription


func scroll_skill_animation(skill, rarity):
	var time_animation : float = 0
	match rarity:
		1:
			time_animation = 1.2
		2:
			time_animation = 1.7
		3:
			time_animation = 2.6
		4:
			time_animation = 4

	for i in skills_textures.get_children():
		var random_skill = texture_skill.keys()[
			randi() % texture_skill.keys().size()
		]
		i.texture = _get_atlas_texture(texture_skill[random_skill])

	last_skill_texture.texture = _get_atlas_texture(texture_skill[skill])

	create_tween().tween_property($VScrollBar, "scroll_vertical", 512*25, time_animation).set_trans(Tween.TRANS_QUAD)
