extends TextureRect

# Скорость анимации (продолжительность одного цикла в секундах)
@export var animation_duration: float = 1.0

# Масштаб увеличения объекта
@export var max_scale: float = 1.1

# Ссылка на Tween
var tween: Tween

func _ready():
	# Создаем Tween
	tween = create_tween()

	# Настройка бесконечной анимации
	tween.tween_property(self, "scale", Vector2(max_scale, max_scale), animation_duration / 2)
	tween.tween_property(self, "scale", Vector2(1, 1), animation_duration / 2)
	tween.set_loops()  # Бесконечный цикл

func _exit_tree():
	# Очищаем Tween при выходе из дерева сцены
	if tween:
		tween.kill()
