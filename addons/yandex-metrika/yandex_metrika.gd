extends Node


static func ym(code: int, type: String, target_name: String):
	var DEBUG: bool = false

	if OS.get_name() == "Web" and not DEBUG:
		var js_window: JavaScriptObject = JavaScriptBridge.get_interface("window")
		js_window.ym(code, type, target_name)
	else:
		prints("ym", code, type, target_name)
