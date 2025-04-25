extends Node


static func ym(code: int, type: String, target_name: String):
	var DEBUG: bool = false

	if OS.get_name() == "Web":
		var js_window: JavaScriptObject = JavaScriptBridge.get_interface("window")
		#js_window.ym(code, type, target_name)
		if DEBUG:
			prints("ym", code, type, target_name)
	else:
		prints("call ym(", str(code), type, target_name, ")")
