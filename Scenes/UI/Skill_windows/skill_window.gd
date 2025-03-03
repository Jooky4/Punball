extends Control

var discription = ""
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

func update_discription(new_discription) -> void:
	discription = new_discription

func show_rarity_window(rarity : int) -> void:
	scroll_skill_animation(rarity)
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

func scroll_skill_animation(rarity):
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
	for i in $VScrollBar/Texture_skills.get_children():
		i.texture = texture_skill[texture_skill.keys()[randi() % texture_skill.keys().size()]]
	$VScrollBar/Texture_skills/TextureRect40.texture = texture_skill[discription]
	create_tween().tween_property($VScrollBar, "scroll_vertical", 512*40, time_animation).set_trans(Tween.TRANS_QUAD)
