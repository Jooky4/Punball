@tool
extends EditorPlugin

var export_plugin: EditorExportPlugin = null

func _enter_tree() -> void:
	export_plugin = preload("metrika_export_plugin.gd").new()
	add_export_plugin(export_plugin)
	add_autoload_singleton("YandexMetrika", "yandex_metrika.gd")


func _exit_tree() -> void:
	remove_export_plugin(export_plugin)
	remove_autoload_singleton("YandexMetrika")
	export_plugin = null
