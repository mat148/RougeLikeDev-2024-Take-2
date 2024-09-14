class_name FieldOfView
extends Node

@onready var tileMap: TileMap = %TileMap

const multipliers = [
	[1, 0, 0, -1, -1, 0, 0, 1],
	[0, 1, -1, 0, 0, -1, 1, 0],
	[0, 1, 1, 0, 0, -1, -1, 0],
	[1, 0, 0, 1, -1, 0, 0, -1]
]

var _fov: Array[TileGrid] = []

func update_fov(map_data: MapDataGrid, origin: Vector3i, radius: int) -> void:
	_clear_fov(map_data)
	
	var start_tile: TileGrid = map_data.get_tile(origin)
	start_tile.is_in_view = true
	update_tile(start_tile)
	
	_fov = [start_tile]
	
	var layers_to_cast = [origin.z]
	for zPos: int in range(origin.z + 1, origin.z + 8, 1):
		if zPos >= 0:
			layers_to_cast.append(zPos)
	for zNeg: int in range(origin.z - 7, origin.z, 1):
		if zNeg >= 0:
			layers_to_cast.append(zNeg)
	
	for layer in layers_to_cast:
		tileMap.get_layers_count()
		if tileMap.get_layer_name(layer) != "":
			for i in 8:
				_cast_light(map_data, origin.x, origin.y, layer, radius, 1, 1.0, 0.0, multipliers[0][i], multipliers[1][i], multipliers[2][i], multipliers[3][i])

func update_tile(tile: TileGrid) -> void:
	var tile_position = Grid.world_to_grid(tile.grid_position)
	var tile_rotation = tile.tile_rotation
	var tile_definition: TileDefinition = tile._definition
	var tile_texture = tile.texture
	var tile_region: Rect2i = tile_texture.region
	var atlas_coords: Vector2i = tile_region.position / 16
	
	tileMap.set_cell(tile_position.z, Vector2i(tile_position.x, tile_position.y), 0, atlas_coords, tile_rotation)

func _clear_fov(map_data: MapDataGrid) -> void:
	for tile in _fov:
		tile.is_in_view = false
		update_tile(tile)
		
	_fov = []

func _cast_light(map_data: MapDataGrid, x: int, y: int, z: int, radius: int, row: int, start_slope: float, end_slope: float, xx: int, xy: int, yx: int, yy: int) -> void:
	if start_slope < end_slope:
		return
	var next_start_slope: float = start_slope
	for i in range(row, radius + 1):
		var blocked: bool = false
		var dy: int = -i
		for dx in range(-i, 1):
			var l_slope: float = (dx - 0.5) / (dy + 0.5)
			var r_slope: float = (dx + 0.5) / (dy - 0.5)
			if start_slope < r_slope:
				continue
			elif end_slope > l_slope:
				break
			var sax: int = dx * xx + dy * xy
			var say: int = dx * yx + dy * yy
			if ((sax < 0 and absi(sax) > x) or (say < 0 and absi(say) > y)):
				continue
			var ax: int = x + sax
			var ay: int = y + say
			if ax >= map_data.width or ay >= map_data.height:
				continue
			var radius2: int = radius * radius
			var current_tile: TileGrid = map_data.get_tile(Vector3i(ax, ay, z))
			if (dx * dx + dy * dy) < radius2:
				current_tile.is_in_view = true
				update_tile(current_tile)
				_fov.append(current_tile)
			if blocked:
				if not current_tile.is_transparent():
					next_start_slope = r_slope
					continue
				else:
					blocked = false
					start_slope = next_start_slope
			elif not current_tile.is_transparent():
				blocked = true
				next_start_slope = r_slope
				_cast_light(map_data, x, y, z, radius, i + 1, start_slope, l_slope, xx, xy, yx, yy)
		if blocked:
			break
