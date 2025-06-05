extends Node

"""
Загружает файлы по сети или выдаёт загруженный файл
"""



@onready var downloader: Node = $Downloader

var _pool: Dictionary = {
	"some.pck": true
}


var url: String
var current_load_url: String
var _is_loading: bool
var load_pck_name = ""
var _load_pck_path = "res://"

signal download_end


func is_loading() -> bool:
	return _is_loading


func _get_current_url() -> String:
	var js_window = JavaScriptBridge.get_interface("window")
	var current_url = js_window.location.origin + js_window.location.pathname

	return current_url


func _ready() -> void:
	if OS.get_name() == "Web":
		url = _get_current_url()
		url = url
		url = url.replace("index.html", "")
		prints("current url", url)

	downloader.download_start.connect(_on_start_loading)
	downloader.download_progress.connect(_on_loading_progress)
	#downloader.request_completed.connect(_on_request_completed)
	downloader.download_end.connect(_on_loaded)


#func _on_request_completed(result, response_code, headers, body):
	#if result == HTTPRequest.RESULT_SUCCESS:
		#var file = FileAccess.open("user://downloaded_file.txt", FileAccess.WRITE)
		#file.store_buffer(body)
		#file.close()
		#print("Файл сохранен: user://downloaded_file.txt")
	#else:
		#print("Ошибка загрузки: " + str(result))


func _on_start_loading(body_size: int) -> void:
	prints("_on_start_loading", body_size)
	_is_loading = true


func _on_loading_progress(body_size: int, loaded_size: int) -> void:
	prints("loading progress", body_size, loaded_size)


func _on_loaded(result, response_code):
	#prints("file loaded", current_load_url, result, response_code)
	_is_loading = false

	_pool[current_load_url] = true

	if result == HTTPRequest.RESULT_SUCCESS:
		var _path = _load_pck_path + load_pck_name
		#prints("file loaded!", "then load_pack(%s)" % _path)
		load_pack(_path)


func is_file_loaded(file_url: String) -> bool:
	#prints("is file loaded?", file_url, _pool)
	return _pool.has(file_url)


func download_pack(relative_url: String, pck_name: String) -> void:
	var _url = url + relative_url
	load_pck_name = pck_name
	current_load_url = relative_url
	#prints("download_pack", _url, _load_pck_path + load_pck_name)
	downloader.download_file(_url, _load_pck_path + load_pck_name)


func load_pack(path: String) -> void:
	#prints("load_pack()")
	var success = ProjectSettings.load_resource_pack(path)
	download_end.emit()

	if success:
		prints("load_pack() success")
