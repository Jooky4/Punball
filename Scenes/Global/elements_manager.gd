extends Node

enum {
	FIRE,  # bomb_ball
	FROST, # freezing_ball
	LASER, # crumbling_ball
	LIGHTNING,
	DARKNESS
}

var color_elements = {
	FIRE : Color.RED,
	FROST: Color.SKY_BLUE, 
	LASER: Color.YELLOW, 
	LIGHTNING: Color.BLUE_VIOLET,
	DARKNESS : Color.NAVY_BLUE
}

var fire_modifier : float = 1.0
var frost_modifier : float = 1.0
var laser_modifier : float = 1.0
var lightning_modifier : float = 1.0
var darkness_modifier : float = 1.0
