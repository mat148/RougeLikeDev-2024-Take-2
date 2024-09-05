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
	sidewalk_corner_large
}

enum tile_group_names {
	center_road_group,
	horizontal_road_group,
	vertical_road_group,
	plot_group
}

#@export var tile_definitions: Dictionary
#@export var tile_atlas_to_type: Dictionary
#@export var tile_groups: Dictionary

const tile_definitions: Dictionary = {
	tile_names.air: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_air.tres"),
	tile_names.blank: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_blank.tres"),
	tile_names.grass_1: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_grass_1.tres"),
	tile_names.grass_4: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_grass_4.tres"),
	tile_names.tree_1: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_tree_1.tres"),
	tile_names.door_1: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_door_1.tres"),
	tile_names.wall_1: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_wall_1.tres"),
	tile_names.road_edge: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_road_edge.tres"),
	tile_names.road_median_lines: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_road_median_lines.tres"),
	tile_names.road_median_lines_corner: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_road_median_lines_corner.tres"),
	tile_names.road_median_lines_t: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_road_median_lines_t.tres"),
	tile_names.road_median_lines_cross: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_road_median_lines_cross.tres"),
	tile_names.sidewalk_edge: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_sidewalk_edge.tres"),
	tile_names.sidewalk_corner_large: preload("res://assets/definitions/tiles/individual_tiles/tile_definition_sidewalk_corner_large.tres")
}

const tile_groups: Dictionary = {
	tile_group_names.center_road_group: preload("res://assets/definitions/tiles/tile_groups/center_road_definition.tscn"),
	tile_group_names.horizontal_road_group: preload("res://assets/definitions/tiles/tile_groups/horizontal_road_definition.tscn"),
	tile_group_names.vertical_road_group: preload("res://assets/definitions/tiles/tile_groups/vertical_road_definition.tscn"),
	tile_group_names.plot_group: preload("res://assets/definitions/tiles/tile_groups/plot_definition.tscn")
}

const tile_atlas_to_type = {
	Vector2i(0, 0): tile_names.blank,
	Vector2i(1, 0): tile_names.grass_1,
	Vector2i(7, 0): tile_names.grass_4,
	
	Vector2i(0, 1): tile_names.tree_1,
	
	Vector2i(2, 9): tile_names.door_1,
	
	Vector2i(10, 17): tile_names.wall_1,
	
	Vector2i(13, 0): tile_names.road_edge,
	
	Vector2i(13, 1): tile_names.road_median_lines,
	Vector2i(14, 1): tile_names.road_median_lines_corner,
	Vector2i(15, 1): tile_names.road_median_lines_t,
	Vector2i(16, 1): tile_names.road_median_lines_cross,
	
	Vector2i(7, 3): tile_names.sidewalk_edge,
	Vector2i(8, 3): tile_names.sidewalk_corner_large,
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
