class_name TileWFC
extends Sprite2D

@export var _definition: TileDefinition

#@export var possibilities: Dictionary = {
	#'TILE_FLOOR': preload("res://assets/definitions/tiles/tile_definition_floor.tres"),
	#'TILE_TREE': preload("res://assets/definitions/tiles/tile_definition_tree.tres"),
	#'TILE_WALL': preload("res://assets/definitions/tiles/tile_definition_wall.tres")
#}
var possibilities: Array

var tile_config = preload("res://assets/definitions/tiles/tile_config.tres")

var entropy: int = 0

var neighbors: Dictionary = {}

var is_explored: bool = false:
	set(value):
		is_explored = value
		if is_explored and not visible:
			visible = true

var is_in_view: bool = false:
	set(value):
		is_in_view = value
		modulate = _definition.color_lit if is_in_view else _definition.color_dark
		if is_in_view and not is_explored:
			is_explored = true

func _init(grid_position: Vector2i) -> void:
	#list(tileRules.keys())
	possibilities = tile_config.tileRules.keys()
	entropy = possibilities.size()
	#visible = false
	centered = false
	position = Grid.grid_to_world(grid_position)

func set_tile_type(tile_definition: TileDefinition) -> void:
	_definition = tile_definition
	texture = _definition.texture
	modulate = _definition.color_dark

func is_walkable() -> bool:
	return _definition.is_walkable

func is_transparent() -> bool:
	return _definition.is_transparent

func add_neighbor(direction: String, tile: TileWFC) -> void:
	neighbors[direction] = tile

func get_neighbor(direction: String) -> TileWFC:
	return neighbors[direction]

func get_directions() -> Array:
	return neighbors.keys()

func get_possibilities() -> Array:
	return possibilities

func collapse() -> void:
	#var weights = [tileWeights[possibility] for possibility in self.possibilities]
	possibilities = [possibilities.pick_random()]
	entropy = 0
	set_tile_type(tile_config.tileResources[possibilities[0]])

func constrain(neighbourPossibilities: Array, direction: String) -> bool:
	var reduced = false

	if entropy > 0:
		var connectors = []
		for neighbourPossibility in neighbourPossibilities:
			var directionToInt = tile_config.directions[direction]
			connectors.append(tile_config.tileRules[neighbourPossibility][directionToInt])

		# check opposite side
		var opposite
		if direction == 'NORTH': opposite = 'SOUTH'
		if direction == 'EAST':  opposite = 'WEST'
		if direction == 'SOUTH': opposite = 'NORTH'
		if direction == 'WEST':  opposite = 'EAST'

		for possibility in possibilities:
			var directionToInt = tile_config.directions[opposite]
			if tile_config.tileRules[possibility][directionToInt] not in connectors:
				possibilities.erase(possibility)
				reduced = true
		
		entropy = possibilities.size()
	
	if entropy == 0:
		printerr("No tile possiblity")
		set_tile_type(tile_config.tileResources['TILE_FLOOR'])
	return reduced
