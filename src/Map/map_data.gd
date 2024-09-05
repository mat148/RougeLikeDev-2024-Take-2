class_name MapData
extends RefCounted

const tile_types = {
	"floor": preload("res://assets/definitions/tiles/individual_tiles/tile_definition_floor.tres"),
	"wall": preload("res://assets/definitions/tiles/individual_tiles/tile_definition_wall_1.tres"),
	"tree": preload("res://assets/definitions/tiles/individual_tiles/tile_definition_tree_1.tres"),
}

var area: Rect2i
var width: int
var height: int
var tiles: Array = []


func _init(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	area = Rect2i(0, 0, map_width, map_height)
	_setup_tiles()


func _setup_tiles() -> void:
	tiles = []
	for x in range(0, width, 1):
		tiles.append([]);
		for y in range(0, height, 1):
			var tile := Tile.new(Vector2i(x, y), tile_types.wall)
			tiles[x].append(tile);

func is_tile_in_bounds(tile: Tile) -> bool:
	return tiles.has(tile)

func is_in_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
	)


func get_tile(grid_position: Vector2i) -> Tile:
	#var tile_index: int = grid_to_index(grid_position)
	#if tile_index == -1:
		#return null
	return tiles[grid_position.x][grid_position.y]


func grid_to_index(grid_position: Vector2i) -> int:
	if not is_in_bounds(grid_position):
		return -1
	return grid_position.y * width + grid_position.x
