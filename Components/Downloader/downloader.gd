extends Node

"""
Скачивает файлы

1) Добавить на основную сцену узел downloader.tscn
2) навесить на этот узел обработчик сигнала download_end
3) вызвать из кода основной сцены $Downloader.download_file(<url>, <filename>)
4) в обработчике (см. пункт 2) обрабатываем скачанный файл
"""

# размеры паков в байтах
# нужно на случай если сервер не сообщает о размере файла
# НЕОБХОДИМО ОБНОВЛЯТЬ ВРУЧНУЮ ПОСЛЕ ИЗМЕНЕНИЙ PCK
var _pck_size_alias = {
	"res://level01.pck": 216416,
	"res://punball.pck": 9314848,
}

@onready var _client: HTTPRequest = $HTTPRequest
var _body_size: int
var _downloaded_bytes: int
var is_downloading: bool = false


signal download_end(result: int, response_code: int)
signal download_progress(from: int, to: int)
signal download_start(body_size: int)


func _ready() -> void:
	_client.request_completed.connect(_request_completed)


func _process(delta: float) -> void:
	if is_downloading:
		_downloaded_bytes = _client.get_downloaded_bytes()
		download_progress.emit(_body_size, _downloaded_bytes)


func _request_completed(result, response_code, headers, body):
	is_downloading = false
	emit_signal("download_end", result, response_code)


func download_file(url: String, output_name: String) -> void:
	prints("download file:", url, output_name)
	is_downloading = true
	_client.download_file = output_name
	_client.request(url, ["Accept-Encoding: identity"])
	var _body_size = _client.get_body_size()
	if _body_size == -1:
		# сервер не возвращает реальный размер файла

		# значит берём заранее известные размеры файлов
		if _pck_size_alias.has(output_name):
			_body_size = _pck_size_alias[output_name]

	download_start.emit(_body_size)
