extends Resource
class_name TileConfig

var directions = {
	'NORTH': 0,
	'EAST': 1,
	'SOUTH': 2,
	'WEST': 3
}

var tileRules = {
	'TILE_GRASS_ONE': [
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL']
	],
	'TILE_GRASS_TWO': [
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL']
	],
	'TILE_GRASS_THREE': [
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL']
	],
	'TILE_FLOWERS': [
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL']
	],
	'TILE_TREE': [
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL']
	],
	'TILE_WALL': [
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['FLOWERS', 'FLOOR', 'WALL', 'WALL_EDGE'],
		['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		['FLOWERS', 'FLOOR', 'WALL', 'WALL_EDGE']
	],
	'TILE_WALL_EDGE': [
		['WALL_EDGE'],
		['WALL'],
		['WALL_EDGE'],
		['WALL']
	],
}

var tileResources = {
	'TILE_GRASS_ONE': preload("res://assets/definitions/tiles/tile_definition_grass.tres"),
	'TILE_GRASS_TWO': preload("res://assets/definitions/tiles/tile_definition_grass_two.tres"),
	'TILE_GRASS_THREE': preload("res://assets/definitions/tiles/tile_definition_grass_three.tres"),
	'TILE_FLOWERS': preload("res://assets/definitions/tiles/tile_definition_flowers.tres"),
	'TILE_FLOOR': preload("res://assets/definitions/tiles/tile_definition_floor.tres"),
	'TILE_TREE': preload("res://assets/definitions/tiles/tile_definition_tree.tres"),
	'TILE_WALL': preload("res://assets/definitions/tiles/tile_definition_wall.tres"),
	'TILE_WALL_EDGE': preload("res://assets/definitions/tiles/tile_definition_wall_edge.tres")
}
