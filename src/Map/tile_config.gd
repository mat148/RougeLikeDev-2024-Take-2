extends Resource
class_name TileConfig

var directions = {
	'NORTH': 0,
	'EAST': 1,
	'SOUTH': 2,
	'WEST': 3
}

var tileRules = {
	#'TILE_FLOOR': [
		##NORTH
		#[''],
		##EAST
		#[''],
		##SOUTH
		#[''],
		##WEST
		#['']
	#],
	
	'TILE_GRASS_ONE': [
		#NORTH
		['TILE_GRASS_ONE', 'TILE_SIDEWALK_SOUTH'],
		#EAST
		['TILE_GRASS_ONE', 'TILE_SIDEWALK_WEST'],
		#SOUTH
		['TILE_GRASS_ONE', 'TILE_SIDEWALK_NORTH'],
		#WEST
		['TILE_GRASS_ONE', 'TILE_SIDEWALK_EAST']
	],
	
	##ROADS
	
	##SIDEWALKS
	'TILE_SIDEWALK_NORTH': [
		#NORTH
		['TILE_GRASS_ONE'],
		#EAST
		['TILE_SIDEWALK_NORTH', 'TILE_SIDEWALK_CORNER_LARGE_NE'],
		#SOUTH
		['TILE_SIDEWALK_SOUTH'],
		#WEST
		['TILE_SIDEWALK_NORTH', 'TILE_SIDEWALK_CORNER_LARGE_NW']
	],
	'TILE_SIDEWALK_EAST': [
		#NORTH
		['TILE_SIDEWALK_EAST', 'TILE_SIDEWALK_CORNER_LARGE_NE'],
		#EAST
		['TILE_GRASS_ONE'],
		#SOUTH
		['TILE_SIDEWALK_EAST', 'TILE_SIDEWALK_CORNER_LARGE_SE'],
		#WEST
		['TILE_SIDEWALK_WEST']
	],
	'TILE_SIDEWALK_SOUTH': [
		#NORTH
		['TILE_SIDEWALK_NORTH'],
		#EAST
		['TILE_SIDEWALK_SOUTH', 'TILE_SIDEWALK_CORNER_LARGE_SE'],
		#SOUTH
		['TILE_GRASS_ONE'],
		#WEST
		['TILE_SIDEWALK_SOUTH', 'TILE_SIDEWALK_CORNER_LARGE_SW']
	],
	'TILE_SIDEWALK_WEST': [
		#NORTH
		['TILE_SIDEWALK_WEST', 'TILE_SIDEWALK_CORNER_LARGE_NW'],
		#EAST
		['TILE_SIDEWALK_EAST'],
		#SOUTH
		['TILE_SIDEWALK_WEST', 'TILE_SIDEWALK_CORNER_LARGE_SW'],
		#WEST
		['TILE_GRASS_ONE']
	],
	
	'TILE_SIDEWALK_CORNER_LARGE_NW': [
		#NORTH
		['TILE_GRASS_ONE'],
		#EAST
		['TILE_SIDEWALK_NORTH'],
		#SOUTH
		['TILE_SIDEWALK_WEST'],
		#WEST
		['TILE_GRASS_ONE']
	],
	'TILE_SIDEWALK_CORNER_LARGE_NE': [
		#NORTH
		['TILE_GRASS_ONE'],
		#EAST
		['TILE_GRASS_ONE'],
		#SOUTH
		['TILE_SIDEWALK_EAST'],
		#WEST
		['TILE_SIDEWALK_NORTH']
	],
	'TILE_SIDEWALK_CORNER_LARGE_SE': [
		#NORTH
		['TILE_SIDEWALK_EAST'],
		#EAST
		['TILE_GRASS_ONE'],
		#SOUTH
		['TILE_GRASS_ONE'],
		#WEST
		['TILE_SIDEWALK_SOUTH']
	],
	'TILE_SIDEWALK_CORNER_LARGE_SW': [
		#NORTH
		['TILE_SIDEWALK_WEST'],
		#EAST
		['TILE_SIDEWALK_SOUTH'],
		#SOUTH
		['TILE_GRASS_ONE'],
		#WEST
		['TILE_GRASS_ONE']
	]
	#'TILE_GRASS_ONE': [
		#['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		#['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		#['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL'],
		#['GRASS_ONE', 'GRASS_TWO', 'GRASS_THREE', 'FLOWERS', 'FLOOR', 'TREE', 'WALL']
	#],
}

var tileResources = {
	'TILE_FLOOR': preload("res://assets/definitions/tiles/tile_definition_floor.tres"),
	'TILE_GRASS_ONE': preload("res://assets/definitions/tiles/tile_definition_grass.tres"),
	
	##SIDEWALKS
	'TILE_SIDEWALK_NORTH': preload("res://assets/definitions/tiles/sidewalk_tiles/tile_definition_sidewalk_n.tres"),
	'TILE_SIDEWALK_EAST': preload("res://assets/definitions/tiles/sidewalk_tiles/tile_definition_sidewalk_e.tres"),
	'TILE_SIDEWALK_SOUTH': preload("res://assets/definitions/tiles/sidewalk_tiles/tile_definition_sidewalk_s.tres"),
	'TILE_SIDEWALK_WEST': preload("res://assets/definitions/tiles/sidewalk_tiles/tile_definition_sidewalk_w.tres"),
	
	'TILE_SIDEWALK_CORNER_LARGE_NW': preload("res://assets/definitions/tiles/sidewalk_tiles/tile_definition_sidewalk_corner_large_nw.tres"),
	'TILE_SIDEWALK_CORNER_LARGE_NE': preload("res://assets/definitions/tiles/sidewalk_tiles/tile_definition_sidewalk_corner_large_ne.tres"),
	'TILE_SIDEWALK_CORNER_LARGE_SE': preload("res://assets/definitions/tiles/sidewalk_tiles/tile_definition_sidewalk_corner_large_se.tres"),
	'TILE_SIDEWALK_CORNER_LARGE_SW': preload("res://assets/definitions/tiles/sidewalk_tiles/tile_definition_sidewalk_corner_large_sw.tres")
	
	#'TILE_GRASS_ONE': preload("res://assets/definitions/tiles/tile_definition_grass.tres"),
	#'TILE_GRASS_TWO': preload("res://assets/definitions/tiles/tile_definition_grass_two.tres"),
	#'TILE_GRASS_THREE': preload("res://assets/definitions/tiles/tile_definition_grass_three.tres"),
	#'TILE_FLOWERS': preload("res://assets/definitions/tiles/tile_definition_flowers.tres"),
	#'TILE_FLOOR': preload("res://assets/definitions/tiles/tile_definition_floor.tres"),
	#'TILE_TREE': preload("res://assets/definitions/tiles/tile_definition_tree.tres"),
	#'TILE_WALL': preload("res://assets/definitions/tiles/tile_definition_wall.tres"),
	#'TILE_WALL_EDGE': preload("res://assets/definitions/tiles/tile_definition_wall_edge.tres")
}
