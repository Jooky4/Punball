extends GenericBall


func _ready() -> void:
	super()
	hit_enemy_sound_name = "-"


func collide_with_enemy(collider) -> void:
	var damage_ball_plus = 0
	if "Усиление особого шара" in LevelManager.player_skills:
		damage_ball_plus = round(damage_ball * 0.05)
	LevelManager.lighthing_ball_damage(collider, (damage_ball + damage_ball_plus) * ElementsManager.lightning_modifier, ElementsManager.color_elements["LIGHTNING"], true)
	collider.deal_damage((damage_ball + damage_ball_plus) * ElementsManager.lightning_modifier, ElementsManager.color_elements["LIGHTNING"])
