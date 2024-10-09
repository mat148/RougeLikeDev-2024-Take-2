class_name MapDataGrid
extends RefCounted

const tile_config = preload("res://assets/definitions/tiles/tile_config.tres")
const entity_pathfinding_weight = 10.0

var area: Rect2i
var width: int
var height: int
var depth: int
var building_plot_size: Vector3
var building_plot_position: Vector3
var tiles: Array
var entities: Array[Entity]
var player: Entity
var pathfinder: AStarGrid2D

var current_layer: int = 0

func _init(map_width: int, map_height: int, map_depth: int, new_building_plot_size: Vector3, new_building_plot_position: Vector3, player: Entity) -> void:
	width = map_width
	height = map_height
	depth = map_depth
	#self.player = player
	area = Rect2i(0, 0, map_width, map_height)
	building_plot_size = new_building_plot_size
	building_plot_position = new_building_plot_position
	entities = []
	_setup_tiles()

func _setup_tiles() -> void:	
	tiles = []
	for x in range(0, width, 1):
		var tiles_2d = []
		for y in range(0, height, 1):
			var tiles_1d = []
			for z in range(0, depth, 1):
				var tile := TileGrid.new(Vector3i(x, y, z), tile_config.get_tile_defininition(TileConfig.tile_names.grass_1))
				tiles_1d.append(tile)
			tiles_2d.append(tiles_1d)
		tiles.append(tiles_2d)

func is_tile_in_bounds(tile: TileGrid) -> bool:
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

func get_tile(grid_position: Vector3i) -> TileGrid:
	return tiles[grid_position.x][grid_position.y][grid_position.z]

func grid_to_index(grid_position: Vector3i) -> int:
	if not is_in_bounds(grid_position):
		return -1
	return grid_position.y * width + grid_position.x

func get_blocking_entity_at_location(grid_position: Vector3i) -> Entity:
	for entity in entities:
		if entity.is_blocking_movement() and entity.grid_position == grid_position:
			return entity
	return null

func register_blocking_entity(entity: Entity) -> void:
	var converted_entity_position: Vector2i = Vector2i(entity.grid_position.x, entity.grid_position.y)
	pathfinder.set_point_weight_scale(converted_entity_position, entity_pathfinding_weight)

func unregister_blocking_entity(entity: Entity) -> void:
	var converted_entity_position: Vector2i = Vector2i(entity.grid_position.x, entity.grid_position.y)
	pathfinder.set_point_weight_scale(converted_entity_position, 0)

func setup_pathfinding() -> void:
	pathfinder = AStarGrid2D.new()
	pathfinder.region = Rect2i(0, 0, width, height)
	pathfinder.update()
	for z in depth:
		for y in height:
			for x in width:			
				var grid_position := Vector3i(x, y, z)
				var tile: TileGrid = get_tile(grid_position)
				var converted_entity_position: Vector2i = Vector2i(grid_position.x, grid_position.y)
				pathfinder.set_point_solid(converted_entity_position, not tile.is_walkable())
	for entity in entities:
		if entity.is_blocking_movement():
			register_blocking_entity(entity)

func get_actors() -> Array[Entity]:
	var actors: Array[Entity] = []
	for entity in entities:
		if entity.is_alive() && entity.is_in_group("actors"):
			actors.append(entity)
	return actors

func get_actor_at_location(location: Vector3i) -> Entity:
	for actor in get_actors():
		if actor.grid_position == location:
			return actor
	return null

func get_interactables() -> Array[Entity]:
	var interactables: Array[Entity] = []
	for interactable in entities:
		if interactable.is_in_group("interactable"):
			interactables.append(interactable)
	return interactables

func get_interactable_at_location(location: Vector3i) -> Entity:
	for interactable in get_interactables():
		if interactable.grid_position == location:
			return interactable
	return null
