extends Resource
class_name TileConfig

var directions = {
	'NORTH': 0,
	'EAST': 1,
	'SOUTH': 2,
	'WEST': 3
}

var tileRules = {
	'TILE_FLOOR': ['FLOOR', 'FLOOR', 'FLOOR', 'FLOOR'],
	'TILE_TREE': ['TREE', 'TREE', 'TREE', 'TREE'],
	'TILE_WALL': ['TREE', 'TREE', 'FLOOR', 'FLOOR'],
}
