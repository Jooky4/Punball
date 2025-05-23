extends Node

func timeout(value: float) -> void:
	"""
		Шорткат

		вместо: await get_tree().create_timer(value).timeout
		пишем:  await Utils.timeout(value)
	"""

	await get_tree().create_timer(value).timeout


# Функция для получения текстуры из атласа по координатам сетки
func get_tileset_atlas_texture(tileset_atlas: TileSetAtlasSource, grid_pos: Vector2i) -> AtlasTexture:
	# tileset_atlas можно получить так: tileset.get_source(0)
	var atlas_texture = AtlasTexture.new()

	atlas_texture.atlas = tileset_atlas.get_texture()
	atlas_texture.region = tileset_atlas.get_tile_texture_region(grid_pos)

	return atlas_texture
