extends Node
"""
Пул объектов

Что делает:
	* заранее создаёт нужное количество экземпляров объекта
	* добавляет все экземпляры на свою сцену ( add_child(obj) )
	* сам заботится о создании или переиспользовании экземпляра объекта

Как пользоваться:
	# 1) запрашиваем объект
	var potion = ObjectPool.get_object("experience_potion")

	# 2) что-то делаем с объектом (задаём позицию, перемещаем и пр.)
	potion.position = Vector2(100, 100)

	# 3) когда объект не нужен, возвращаем обратно в пул
	ObjectPool.return_object("experience_potion", potion)
"""

# Связь имени и Префаба/Сцены
@onready var _object_aliases: Dictionary = {
	"experience_potion": preload("res://Scenes/Bonus/bank_with_experience.tscn"),
	"heal_potion": preload("res://Scenes/Bonus/restore_health.tscn"),
	"enemy_death_effect": preload("res://Scenes/Enemys/Dops/death_effect.tscn"),
	"enemy_damage_label": preload("res://Scenes/Enemys/Dops/label_enemy_damage.tscn")
}

# Количество заранее создаваемых экземпляров объекта
var _object_preinstance: Dictionary = {
	"experience_potion": 3,
	"heal_potion": 1,
	"enemy_death_effect": 4,
	"enemy_damage_label": 1,
}

# хранилище созданных экземпляров
var _object_pools: Dictionary = {
	"experience_potion": [],
	"heal_potion": [],
	"enemy_death_effect": [],
	"enemy_damage_label": [],
}

var _DEBUG: bool = false
@onready var debug_label: Label = $DebugLabel
@onready var objects: Node2D = $Objects


func _ready() -> void:
	debug_label.visible = _DEBUG

	if _DEBUG:
		prints("start")
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = false
		timer.wait_time = 0.5
		timer.timeout.connect(_on_debug_update_timer_timeout)
		timer.start()

	for i in _object_preinstance.keys():
		var _name = i
		var _count = _object_preinstance[i]
		for _j in _count:
			var _obj = _object_aliases[_name].instantiate()
			objects.add_child(_obj)
			_obj.hide()

			if _DEBUG:
				_obj.modulate = Color(1, 0, 0)

			if not _object_pools.has(_name):
				_object_pools[_name] = []

			_object_pools[_name].push_back(_obj)


# TODO: проверять что имя не занято
func register_object(name: String, scene: PackedScene) -> void:
	""" Добавляет в реест новый тип объекта """
	_object_aliases[name] = scene


func get_object(name: String) -> Node:
	""" Возвращает объект если он есть в пуле или создаёт новый """

	var result: Node

	if _object_aliases.has(name):
		if _object_pools.has(name):
			var _obj_list = _object_pools[name]
			if _obj_list.size():
				var _obj = _obj_list.pop_back()
				_obj.show()
				return _obj

		var _obj = _object_aliases[name].instantiate()
		objects.add_child(_obj)
		return _obj

	return null


func return_object(name: String, obj: Node) -> void:
	""" Возврат использованного объекта в пул """

	if _DEBUG:
		obj.modulate = Color(1, 0, 0)

	obj.hide()
	obj.position = Vector2.ZERO

	if _object_pools.has(name):
		_object_pools[name].push_back(obj)
	else:
		_object_pools[name] = [obj]


func cleanup() -> void:
	# удаление всех дочерних объектов, не находящиеся в пуле

	var all_pools: Array
	for i in _object_pools.values():
		all_pools.append_array(i)

	for i in objects.get_children():
		if i not in all_pools:
			objects.remove_child(i)


func _on_debug_update_timer_timeout() -> void:
	var _str: String

	for i in _object_pools.keys():
		_str += "%s: %d\n" %[i, _object_pools[i].size()]

	debug_label.text = _str
