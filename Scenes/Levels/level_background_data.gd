class_name LevelBackgroundData extends Resource


const background_path = "res://Texture/Backgrounds/"
const background_url = "locations_bg/"
#const background_url = ""

static var file_aliases = {
	0: "location_1.png",
	1: "location_2.png",
	2: "location_3.png",
	3: "location_4.png",
	4: "location_5.png",
	5: "location_6.png",
	6: "location_7.png",
	7: "location_8.png",
	8: "location_9.png",
	-1: "location_10.png",
}

static var pck_aliases = {
	0: "location_bg_1.pck",
	1: "location_bg_2.pck",
	2: "location_bg_3.pck",
	3: "location_bg_4.pck",
	4: "location_bg_5.pck",
	5: "location_bg_6.pck",
	6: "location_bg_7.pck",
	7: "location_bg_8.pck",
	8: "location_bg_9.pck",
	-1: "location_bg_10.pck",
}


static func get_level_bg_path(index: int) -> String:
	return background_path + file_aliases[index]


static func get_level_bg_url(index: int) -> String:
	return background_url + pck_aliases[index]


static func get_level_pck_name(index: int) -> String:
	return pck_aliases[index]
