extends Control

var regular = ["Шар-заморозка", "Усиление обычного шара", "Огненный шар", "Усиление особого шара", "Последний рывок", "Суперначало"]
var rare = ["Шар молний",  "Рассыпающийся шар", "Шар-бомба", "Прибавка ОЗ", "Бомба-заморозка", "Молния: комбо", "Лед: комбо", "Огонь: комбо", "Вертикальный лазерный шар", "Горизонтальный лазерный шар", "Шар ракета", "Кумулятивный шар", "Ядерная: комбо", "Шар удара в спину", "Шар убийца", "Бурящий шар", "Технология: комбо с тыла", "Технология: комбо с фронта", "Прибавка к восстановлению"] 
var epic = ["Усиление атаки", "Молния смерти", "Холод смерти", "Бомба смерти", "Лазер смерти", "Лазер: комбо", "Ракета смерти", "Ловушка","Комбо: скидка"]
var legendary = ["Повелитель молний", "Повелитель льда", "Повелитель огня", "Повелитель лазера", "Повелитель атома", "Повелитель технологий", "Оживление"]

var regular_ramk = preload("res://Texture/UI/Pause_UI/обычная.png")
var rare_ramk = preload("res://Texture/UI/Pause_UI/редкая.png")
var epic_ramk = preload("res://Texture/UI/Pause_UI/эпическая.png")
var legendary_ramk = preload("res://Texture/UI/Pause_UI/легенда.png")

var texture_skill = {
	"Шар-заморозка": preload("res://Texture/UI/Texture_skills/шар заморозка.png"),
	"Усиление обычного шара": preload("res://Texture/UI/Texture_skills/усиление обычного шара.png"),
	"Рассыпающийся шар": preload("res://Texture/UI/Texture_skills/рассыпающийся шар.png"),
	"Шар-бомба": preload("res://Texture/UI/Texture_skills/шар бомба.png"),
	"Усиление особого шара": preload("res://Texture/UI/Texture_skills/усиление особенного шара.png"),
	"Прибавка ОЗ": preload("res://Texture/UI/Texture_skills/прибавка 03.png"),
	"Шар молний": preload("res://Texture/UI/Texture_skills/шар молния.png"),
	"Бомба-заморозка": preload("res://Texture/UI/Texture_skills/бомба заморозки.png"),
	"Огненный шар": preload("res://Texture/UI/Texture_skills/огненный шар2.png"),
	"Усиление атаки": preload("res://Texture/UI/Texture_skills/усиление атаки.png"),
	"Молния смерти": preload("res://Texture/UI/Texture_skills/молния смерти.png"),
	"Холод смерти": preload("res://Texture/UI/Texture_skills/холод смерти.png"),
	"Бомба смерти": preload("res://Texture/UI/Texture_skills/бомба смерти.png"),
	"Повелитель молний": preload("res://Texture/UI/Texture_skills/повелитель молний.png"),
	"Повелитель льда": preload("res://Texture/UI/Texture_skills/повелитель холода.png"),
	"Повелитель огня": preload("res://Texture/UI/Texture_skills/повелитель огня.png"),
	"Молния: комбо": preload("res://Texture/UI/Texture_skills/молния комбо.png"), 
	"Лед: комбо": preload("res://Texture/UI/Texture_skills/комбо лёд.png"), 
	"Огонь: комбо": preload("res://Texture/UI/Texture_skills/огонь комбо.png"), 
	"Вертикальный лазерный шар": preload("res://Texture/UI/Texture_skills/шар верт. лазер.png"), 
	"Горизонтальный лазерный шар": preload("res://Texture/UI/Texture_skills/шар горизонт. лазер.png"), 
	"Лазер смерти": preload("res://Texture/UI/Texture_skills/лазер смерти.png"),
	"Повелитель лазера": preload("res://Texture/UI/Texture_skills/повелитель лазера.png"), 
	"Лазер: комбо": preload("res://Texture/UI/Texture_skills/лазер комбл.png"), 
	"Суперначало": preload("res://Texture/UI/Texture_skills/суперначало.png"), 
	"Последний рывок": preload("res://Texture/UI/Texture_skills/последний рывок.png"), 
	"Шар ракета": preload("res://Texture/UI/Texture_skills/шар ракета (ядерная).png"), 
	"Кумулятивный шар": preload("res://Texture/UI/Texture_skills/кумулятивный шар.png"), 
	"Ракета смерти": preload("res://Texture/UI/Texture_skills/ракета смерти.png"), 
	"Повелитель атома": preload("res://Texture/UI/Texture_skills/повелитель атома.png"), 
	"Ядерная: комбо": preload("res://Texture/UI/Texture_skills/комбо ядерное.png"),
	"Шар удара в спину": preload("res://Texture/UI/Texture_skills/шар удара в спину.png"), 
	"Шар убийца": preload("res://Texture/UI/Texture_skills/шар убийца (технологии).png"), 
	"Бурящий шар": preload("res://Texture/UI/Texture_skills/бурящий шар.png"), 
	"Ловушка": preload("res://Texture/UI/Texture_skills/ловушка.png"), 
	"Повелитель технологий": preload("res://Texture/UI/Texture_skills/повелитель технологий.png"), 
	"Технология: комбо с тыла": preload("res://Texture/UI/Texture_skills/технология шипы тыл.png"), 
	"Технология: комбо с фронта": preload("res://Texture/UI/Texture_skills/технология шипы фронт.png"), 
	"Комбо: скидка": preload("res://Texture/UI/Texture_skills/скидка комбо.png"), 
	"Прибавка к восстановлению": preload("res://Texture/UI/Texture_skills/прибавка к восстановлению.png"), 
	"Оживление": preload("res://Texture/UI/Texture_skills/оживление.png") 
	}

func _ready() -> void:
	self.visible = false

func _on_continue_pressed() -> void:
	AudioManager.click()
	Engine.time_scale = 1
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	self.visible = false

func update_texture_skill() -> void:
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
		skills_box[i].get_child(0).texture = texture_skill[skill]

func _on_home_pressed() -> void:
	AudioManager.click()
	get_tree().change_scene_to_file("res://Scenes/UI/Menu/menu.tscn")
