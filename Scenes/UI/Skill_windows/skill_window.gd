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
	"Бомба-заморозка": preload("res://Texture/UI/Texture_skills/шар заморозка.png"),
	"Огненный шар": preload("res://Texture/UI/Texture_skills/рассыпающийся шар.png"),
	"Усиление атаки": preload("res://Texture/UI/Texture_skills/усиление обычного шара.png"),
	"Молния смерти": preload("res://Texture/UI/Texture_skills/шар бомба.png"),
	"Холод смерти": preload("res://Texture/UI/Texture_skills/шар заморозка.png"),
	"Бомба смерти": preload("res://Texture/UI/Texture_skills/рассыпающийся шар.png"),
	"Повелитель молний": preload("res://Texture/UI/Texture_skills/шар бомба.png"),
	"Повелитель льда":  preload("res://Texture/UI/Texture_skills/шар заморозка.png"),
	"Повелитель огня": preload("res://Texture/UI/Texture_skills/рассыпающийся шар.png")}

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
