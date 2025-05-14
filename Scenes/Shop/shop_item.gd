@tool
extends TextureButton

@export_enum("coins", "crystal") var type: int
@export var price: int : set = _set_price
@export var count: int
@export var currency: String = "Руб" : set = _set_currency

@export var item_texture: Texture2D

@export var coins_bg_texture: Texture2D
@export var crystal_bg_texture: Texture2D

@export var coin_texture: Texture2D
@export var crystal_texture: Texture2D


@onready var item_image: TextureRect = $TextureRect
@onready var item_count_label: Label = %CountLabel
@onready var price_label: Label = %PriceLabel
@onready var count_image: TextureRect = $HBoxContainer2/TextureRect
@onready var currency_label: Label = $HBoxContainer/Label


func _ready() -> void:
	var current_bg_texture: Texture2D = coins_bg_texture
	var current_count_texture: Texture2D = coin_texture

	if type == 1:
		current_bg_texture = crystal_bg_texture
		current_count_texture = crystal_texture

	texture_normal = current_bg_texture
	item_image.texture = item_texture
	price_label.text = str(price)
	currency_label.text = currency
	item_count_label.text = str(count)
	count_image.texture = current_count_texture


func _set_price(value: int) -> void:
	price = value

	if price_label:
		price_label.text = str(value)


func _set_currency(value: String) -> void:
	currency = value
	if currency_label:
		currency_label.text = value
