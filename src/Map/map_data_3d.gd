class_name MapData3D
extends RefCounted

const tile_types = {
	"floor": preload("res://assets/definitions/tiles/tile_definition_floor.tres"),
	"wall": preload("res://assets/definitions/tiles/tile_definition_wall.tres"),
	"tree": preload("res://assets/definitions/tiles/tile_definition_tree.tres"),
}

var area: Rect2i
var width: int
var height: int
var depth: int
var tiles: Array = []


func _init(map_width: int, map_height: int, map_depth: int) -> void:
	width = map_width
	height = map_height
	depth = map_depth
	#area = Rect2i(0, 0, map_width, map_height)
	_setup_tiles()


func _setup_tiles() -> void:
	tiles = []
	for x in range(0, width, 1):
		var tiles_2d = []
		for y in range(0, height, 1):
			var tiles_1d = []
			for z in range(0, depth, 1):
				var tile := Tile3D.new(Vector3i(x, y, z), tile_types.wall)
				tiles_1d.append(tile)
			tiles_2d.append(tiles_1d)
		tiles.append(tiles_2d)

func is_tile_in_bounds(tile: Tile3D) -> bool:
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


func get_tile(grid_position: Vector3i) -> Tile3D:
	#var tile_index: int = grid_to_index(grid_position)
	#if tile_index == -1:
		#return null
	return tiles[grid_position.x][grid_position.y][grid_position.z]


func grid_to_index(grid_position: Vector3i) -> int:
	if not is_in_bounds(grid_position):
		return -1
	return grid_position.z * width * height + grid_position.y * width + grid_position.x
