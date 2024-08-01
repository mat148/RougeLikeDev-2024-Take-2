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
	area = Rect2i(0, 0, map_width, map_height)
	_setup_tiles()


func _setup_tiles() -> void:
	#lst = []
	#for i in range(x):
		#lst_2d = []
		#for j in range(y):
			#lst_1d = []
			#for k in range(z):
				#lst_1d.append('#')
			#lst_2d.append(lst_1d)
		#lst.append(lst_2d)
	#return lst
	
	tiles = []
	for i in range(0, width, 1):
		var tiles_2d = []
		for j in range(0, height, 1):
			var tiles_1d = []
			for k in range(0, depth, 1):
				var tile := Tile3D.new(Vector3i(i, j, k), tile_types.wall)
				tiles_1d.append(tile)
			tiles_2d.append(tiles_1d)
		tiles.append(tiles_2d)

#func is_tile_in_bounds(tile: Tile) -> bool:
	#return tiles.has(tile)

#func is_in_bounds(coordinate: Vector2i) -> bool:
	#return (
		#0 <= coordinate.x
		#and coordinate.x < width
		#and 0 <= coordinate.y
		#and coordinate.y < height
	#)


func get_tile(grid_position: Vector3i) -> Tile3D:
	#var tile_index: int = grid_to_index(grid_position)
	#if tile_index == -1:
		#return null
	return tiles[grid_position.x][grid_position.y][grid_position.z]


#func grid_to_index(grid_position: Vector2i) -> int:
	#if not is_in_bounds(grid_position):
		#return -1
	#return grid_position.y * width + grid_position.x
