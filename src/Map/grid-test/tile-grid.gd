class_name TileGrid
extends Sprite2D

@export var _definition: TileDefinition
@export var is_walkway: bool = false
@export var tile_rotation: int = 0
var grid_position: Vector3

var is_explored: bool = false:
	set(value):
		is_explored = value
		if is_explored and not visible:
			visible = true

var is_in_view: bool = false:
	set(value):
		is_in_view = value
		texture = _definition.lit_texture if is_in_view else _definition.dark_texture
		if is_in_view and not is_explored:
			is_explored = true

func _init(new_grid_position: Vector3i, tile_definition: TileDefinition) -> void:
	visible = true
	centered = false
	grid_position = Grid.grid_to_world(new_grid_position)
	set_tile_type(tile_definition)


func set_tile_type(tile_definition: TileDefinition) -> void:
	_definition = tile_definition
	texture = _definition.lit_texture


func is_walkable() -> bool:
	return _definition.is_walkable


func is_transparent() -> bool:
	return _definition.is_transparent
