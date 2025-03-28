extends Control

@onready var label_chest = $Label
@onready var texture_close = $Close
@onready var texture_open = $Open
@onready var texture_epty = $Empty #добавил Дима
@onready var button_open_chest = $Open_chest

var location_for_open : int = 0
var wave_for_open : int = 0
var can_open : bool = false

signal chest_opened()

func update_label(new_text) -> void:
	label_chest.text = new_text

func close_chest() -> void:
	texture_close.visible = true
	texture_open.visible = false

func open_chest() -> void:
	texture_close.visible = false
	texture_open.visible = true

func _on_open_chest_pressed() -> void:
	texture_epty.visible = true #добавил Дима
	texture_open.visible = false #добавил Дима
	emit_signal("chest_opened")

func can_open_or_not(arr) -> void:
	location_for_open = int(arr[0])
	wave_for_open = int(arr[1])

	close_chest()
	button_open_chest.disabled = true
	if PlayerIndicatorsManager.CURRENT_LOCATIONS > location_for_open:
		open_chest()
		button_open_chest.disabled = false
		can_open = true
	elif PlayerIndicatorsManager.CURRENT_LOCATIONS == location_for_open:
		if PlayerIndicatorsManager.MAX_WAVE_ON_CURRENT_LOCATIONS >= wave_for_open:
			open_chest()
			button_open_chest.disabled = false
			can_open = true
