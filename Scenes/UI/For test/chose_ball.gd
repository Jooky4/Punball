extends ColorRect

func _on_button_pressed() -> void:
	LevelManager.player_balls = [1]
	get_tree().reload_current_scene()

func _on_button_2_pressed() -> void:
	LevelManager.player_balls = [2]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_3_pressed() -> void:
	LevelManager.player_balls = [3]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_4_pressed() -> void:
	LevelManager.player_balls = [4]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_5_pressed() -> void:
	LevelManager.player_balls = [5]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_6_pressed() -> void:
	LevelManager.player_balls = [6]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_7_pressed() -> void:
	LevelManager.player_balls = [7]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_8_pressed() -> void:
	LevelManager.player_balls = [8]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_9_pressed() -> void:
	LevelManager.player_balls = [9]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_10_pressed() -> void:
	LevelManager.player_balls = [10]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_11_pressed() -> void:
	LevelManager.player_balls = [11]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_12_pressed() -> void:
	LevelManager.player_balls = [12]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_13_pressed() -> void:
	LevelManager.player_balls = [13]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_button_14_pressed() -> void:
	LevelManager.player_balls = [14]
	LevelManager.restert()
	get_tree().reload_current_scene()

func _on_close_menu_pressed() -> void:
	$".".visible = false

func _on_balls_chose_pressed() -> void:
	$Balls.visible = true
	$Main_menu.visible = false

func _on_button_15_pressed() -> void:
	$Balls.visible = false
	$Main_menu.visible = true

func _on_skills_chose_pressed() -> void:
	$Skills.visible = true
	$Main_menu.visible = false

func _on_close_skills_menu_pressed() -> void:
	$Skills.visible = false
	$Main_menu.visible = true

func _on_button_skill_pressed(extra_arg_0: String) -> void:
	extra_arg_0 = extra_arg_0.substr(1, extra_arg_0.length() - 2)
	match extra_arg_0:
		"Усиление обычного шара":
			ElementsManager.normal_modifier += 0.1
		"Прибавка ОЗ":
			var prosen_hp_plus = 0.1
			if "Прибавка к восстановлению" in LevelManager.player_skills:
				prosen_hp_plus *= 1.5
			LevelManager.hp_player = LevelManager.hp_player + (LevelManager.max_hp_player * prosen_hp_plus)
			LevelManager.max_hp_player = LevelManager.max_hp_player * (1 + prosen_hp_plus)
		"Усиление особого шара":
			ElementsManager.fire_modifier += 0.1
			ElementsManager.frost_modifier += 0.1
			ElementsManager.laser_modifier += 0.1
			ElementsManager.lightning_modifier += 0.1
			ElementsManager.nuclear_modifier += 0.1
			ElementsManager.technologies_modifier += 0.1
		"Усиление атаки":
			ElementsManager.normal_modifier += 0.1
			ElementsManager.fire_modifier += 0.1
			ElementsManager.frost_modifier += 0.1
			ElementsManager.laser_modifier += 0.1
			ElementsManager.lightning_modifier += 0.1
			ElementsManager.nuclear_modifier += 0.1
			ElementsManager.technologies_modifier += 0.1
		"Оживление":
			LevelManager.player_skills.append("Оживление")
		"Прибавка к восстановлению":
			LevelManager.player_skills.append("Прибавка к восстановлению")
		"Суперначало":
			LevelManager.player_skills.append("Суперначало")
		"Последний рывок":
			LevelManager.player_skills.append("Последний рывок")
		"Ловушка":
			LevelManager.player_skills.append("Ловушка")
		"Молния смерти":
			LevelManager.player_skills.append("Молния смерти")
		"Холод смерти":
			LevelManager.player_skills.append("Холод смерти")
		"Бомба смерти":
			LevelManager.player_skills.append("Бомба смерти")
		"Лазер смерти":
			LevelManager.player_skills.append("Лазер смерти")
		"Ракета смерти":
			LevelManager.player_skills.append("Ракета смерти")
		"Лазер: комбо":
			LevelManager.player_skills.append("Лазер: комбо")
		"Молния: комбо":
			LevelManager.player_skills.append("Молния: комбо")
		"Лед: комбо":
			LevelManager.player_skills.append("Лед: комбо")
		"Огонь: комбо":
			LevelManager.player_skills.append("Огонь: комбо")
		"Ядерная: комбо":
			LevelManager.player_skills.append("Ядерная: комбо")
		"Технология: комбо с тыла":
			LevelManager.player_skills.append("Технология: комбо с тыла")
		"Технология: комбо с фронта":
			LevelManager.player_skills.append("Технология: комбо с фронта")
		"Комбо: скидка":
			LevelManager.player_skills.append("Комбо: скидка")
		"Повелитель молний":
			LevelManager.count_damage_lightning_enemy = 5
			ElementsManager.lightning_modifier += 0.4
		"Повелитель льда":
			ElementsManager.frost_modifier += 0.4
			LevelManager.chance_of_freezing += 0.3
		"Повелитель огня":
			ElementsManager.fire_modifier += 0.4
			LevelManager.player_skills.append("Повелитель огня")
		"Повелитель лазера":
			ElementsManager.laser_modifier += 0.4
			LevelManager.player_skills.append("Повелитель лазера")
		"Повелитель атома":
			ElementsManager.nuclear_modifier += 0.4
			LevelManager.player_skills.append("Повелитель атома")
		"Повелитель технологий":
			ElementsManager.technologies_modifier += 0.4
			LevelManager.player_skills.append("Повелитель технологий")
	$Skills.visible = false
	$Main_menu.visible = true
	$".".visible = false
