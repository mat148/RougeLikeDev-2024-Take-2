extends Resource
class_name TileConfig

enum tile_names {
	air,
	blank,
	grass_1,
	grass_4,
	tree_1,
	door_1,
	wall_1,
	road_edge,
	road_median_lines,
	road_median_lines_corner,
	road_median_lines_t,
	road_median_lines_cross,
	sidewalk_edge,
	sidewalk_corner_large,
	stairway_up,
	stairway_down
}

enum tile_group_names {
	center_road_group,
	horizontal_road_group,
	vertical_road_group,
	plot_group,
	building_floor_group,
	park_group
}

enum entity_names {
	player,
	enemy,
	stairway_up,
	stairway_down
}

var tile_to_entity: Dictionary = {
	tile_names.stairway_up: entity_names.stairway_up,
	tile_names.stairway_down: entity_names.stairway_down
}

#@export var tile_definitions: Dictionary
#@export var tile_atlas_to_type: Dictionary
#@export var tile_groups: Dictionary

var tile_definitions: Dictionary = {
	tile_names.air: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_air.tres"),
	tile_names.blank: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_blank.tres"),
	tile_names.grass_1: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_grass_1.tres"),
	tile_names.grass_4: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_grass_4.tres"),
	tile_names.tree_1: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_tree_1.tres"),
	tile_names.door_1: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_door_1.tres"),
	tile_names.wall_1: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_wall_1.tres"),
	tile_names.road_edge: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_road_edge.tres"),
	tile_names.road_median_lines: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_road_median_lines.tres"),
	tile_names.road_median_lines_corner: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_road_median_lines_corner.tres"),
	tile_names.road_median_lines_t: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_road_median_lines_t.tres"),
	tile_names.road_median_lines_cross: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_road_median_lines_cross.tres"),
	tile_names.sidewalk_edge: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_sidewalk_edge.tres"),
	tile_names.sidewalk_corner_large: ResourceLoader.load("res://assets/definitions/tiles/individual_tiles/tile_definition_sidewalk_corner_large.tres")
}

const grass_definitions: Dictionary = {
	tile_names.grass_1: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_grass_1.tres")
}

const entity_definition: Dictionary = {
	entity_names.player: preload("res://assets/definitions/entities/actors/player.tscn"),
	entity_names.enemy: preload("res://assets/definitions/entities/actors/enemy.tscn"),
	entity_names.stairway_up: preload("res://assets/definitions/entities/objects/stairway_up.tscn"),
	entity_names.stairway_down: preload("res://assets/definitions/entities/objects/stairway_down.tscn")
}

const tile_groups: Dictionary = {
	tile_group_names.center_road_group: preload("res://assets/definitions/tiles/tile_groups/center_road_definition.tscn"),
	tile_group_names.horizontal_road_group: preload("res://assets/definitions/tiles/tile_groups/horizontal_road_definition.tscn"),
	tile_group_names.vertical_road_group: preload("res://assets/definitions/tiles/tile_groups/vertical_road_definition.tscn"),
	tile_group_names.plot_group: preload("res://assets/definitions/tiles/tile_groups/plot_definition.tscn"),
	tile_group_names.building_floor_group: preload("res://assets/definitions/tiles/tile_groups/building_floor_definition.tscn"),
	tile_group_names.park_group: preload("res://assets/definitions/tiles/tile_groups/park_definition.tscn")
}

const tile_atlas_to_type = {
	Vector2i(1, 0): tile_names.blank,
	Vector2i(3, 0): tile_names.grass_1,
	Vector2i(10, 0): tile_names.grass_4,
	
	Vector2i(0, 1): tile_names.tree_1,
	
	Vector2i(2, 3): tile_names.door_1,
	
	Vector2i(13, 2): tile_names.wall_1,
	
	Vector2i(12, 0): tile_names.road_edge,
	
	Vector2i(9, 1): tile_names.road_median_lines,
	Vector2i(11, 1): tile_names.road_median_lines_corner,
	Vector2i(13, 1): tile_names.road_median_lines_t,
	Vector2i(15, 1): tile_names.road_median_lines_cross,
	Vector2i(15, 2): tile_names.stairway_up,
	Vector2i(17, 2): tile_names.stairway_down,
	
	Vector2i(7, 2): tile_names.sidewalk_edge,
	Vector2i(9, 2): tile_names.sidewalk_corner_large,
}

func get_tile_defininition(tile: int) -> TileDefinition:
	return tile_definitions[tile]

func has_tile_type(tile: int) -> bool:
	return tile_definitions.has(tile)

func has_atlas_type(atlas_coords: Vector2i) -> bool:
	return tile_atlas_to_type.has(atlas_coords)

func has_tile_group(tile_group: int) -> bool:
	return tile_groups.has(tile_group)

func get_tile_group(tile_group: int) -> PackedScene:
	return tile_groups[tile_group]

func has_entity_type(entity: int) -> bool:
	return entity_definition.has(entity)

func get_entity_definition(entity: int) -> PackedScene:
	return entity_definition[entity]
