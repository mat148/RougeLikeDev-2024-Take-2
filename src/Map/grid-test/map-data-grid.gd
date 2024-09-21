class_name MapDataGrid
extends RefCounted

const tile_config = preload("res://assets/definitions/tiles/tile_config.tres")

var area: Rect2i
var width: int
var height: int
var depth: int
var tiles: Array

var entities: Array[EntityNew]

func _init(map_width: int, map_height: int, map_depth: int, player: EntityNew) -> void:
	width = map_width
	height = map_height
	depth = map_depth
	#self.player = player
	area = Rect2i(0, 0, map_width, map_height)
	entities = []
	_setup_tiles()


func _setup_tiles() -> void:	
	tiles = []
	for x in range(0, width, 1):
		var tiles_2d = []
		for y in range(0, height, 1):
			var tiles_1d = []
			for z in range(0, depth, 1):
				var tile := TileGrid.new(Vector3i(x, y, z), tile_config.get_tile_defininition(TileConfig.tile_names.air))
				tiles_1d.append(tile)
			tiles_2d.append(tiles_1d)
		tiles.append(tiles_2d)

func is_tile_in_bounds(tile: TileGrid) -> bool:
	return tiles.has(tile)

func is_in_bounds(coordinate: Vector3i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
		and 0 <= coordinate.z
		and coordinate.z < depth
	)

func get_tile(grid_position: Vector3i) -> TileGrid:
	return tiles[grid_position.x][grid_position.y][grid_position.z]

func grid_to_index(grid_position: Vector3i) -> int:
	if not is_in_bounds(grid_position):
		return -1
	return grid_position.y * width + grid_position.x

func get_blocking_entity_at_location(grid_position: Vector3i) -> EntityNew:
	for entity in entities:
		if entity.is_blocking_movement() and entity.grid_position == grid_position:
			return entity
	return null
