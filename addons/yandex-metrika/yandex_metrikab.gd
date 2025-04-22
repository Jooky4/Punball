extends Node

static func ym(code: int, type: String, target_name: String):
	var js_window: JavaScriptObject = JavaScriptBridge.get_interface("window")
	js_window.ym(code, type, target_name)
