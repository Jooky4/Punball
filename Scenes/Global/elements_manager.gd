extends Node

enum {
	NORMAL,   #defalt_ball
	FIRE,     # bomb_ball
	FROST,    # freezing_ball
	LASER,    # crumbling_ball
	LIGHTNING,
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
