extends Node

enum {
	NORMAL,   # defalt_ball
	FIRE,     # bomb_ball, fire_ball
	FROST,    # freezing_ball, freezing_bomb_ball
	LASER,    # crumbling_ball
	LIGHTNING,# lightning_ball
	DARKNESS
}

var color_elements = {
	"NORMAL" : Color.WHITE,
	"FIRE" : Color.RED,
	"FROST": Color.BLUE, 
	"LASER": Color.YELLOW, 
	"LIGHTNING": Color.BLUE_VIOLET,
	"DARKNESS" : Color.NAVY_BLUE
}

var normal_modifier : float = 1.0
var fire_modifier : float = 1.0
var frost_modifier : float = 1.0
var laser_modifier : float = 1.0
var lightning_modifier : float = 1.0
var darkness_modifier : float = 1.0

func restart():
	normal_modifier = 1.0
	fire_modifier = 1.0
	frost_modifier = 1.0
	laser_modifier = 1.0
	lightning_modifier  = 1.0
	darkness_modifier = 1.0
