class_name GridGenerator
extends Node

var directions = [
	Vector2.UP,
	Vector2.LEFT,
	Vector2.DOWN,
	Vector2.RIGHT
]

@export_category("Map Dimensions")
@export var map_width: int = 132
@export var map_height: int = 132
@export var map_depth: int = 15

@export_category("Rooms RNG")
@export var max_rooms: int = 30
@export var room_max_size: int = 10
@export var room_min_size: int = 6

@export_category("Monsters RNG")
@export var max_monsters_per_room: int = 2

##OBJECTS
const stairs_up_definition = preload("res://assets/definitions/entities/actors/entity_definition_stairs_up.tres")
const stairs_down_definition = preload("res://assets/definitions/entities/actors/entity_definition_stairs_down.tres")

##ITEMS

var _rng := RandomNumberGenerator.new()

var plots: Array[Plot] = []
var buildings: Array[Building] = []
var parks: Array[Park] = []
var roads: Array[Road] = []

var plot_size: int = 11
var road_size: int = 11


func _ready() -> void:
	_rng.randomize()

func generate_dungeon(player: EntityNew) -> MapDataGrid:
	# Check if map_width and map_height are divisible by plot_size
	if map_width % (plot_size) != 0:
		printerr("Error: map_width must be divisible by the plot_size of ", plot_size)
	if map_height % (plot_size) != 0:
		printerr("Error: map_height must be divisible by the plot_size of ", plot_size)
	
	var dungeon := MapDataGrid.new(map_width, map_height, map_depth, player)
	
	var calc_plot_width: int = map_width / plot_size
	var calc_plot_height: int = map_height / plot_size
	
	for y: int in calc_plot_height:
		for x: int in calc_plot_width:
			for z: int in map_depth:
				if z == 0:
					var check_x: int = x % 2
					var check_y: int = y % 2
					
					var location = Vector3i(x * plot_size, y * plot_size, z)
					
					var area
					var points = [
						Vector2i(location.x, location.y),
						Vector2i(location.x + plot_size, location.y),
						Vector2i(location.x + plot_size, location.y + plot_size),
						Vector2i(location.x, location.y + plot_size),
					]
					if check_y == 1:
						if check_x == 0:
							area = Road.new(
								points,
								Vector2i.LEFT,
								location
							)
							roads.append(area)
						else:
							area = Road.new(
								points,
								Vector2i.ZERO,
								location
							)
							roads.append(area)
					else:
						if (x + y) % 2 == 0:
							area = Plot.new(
								points,
								location
							)
						else:
							area = Road.new(
								points,
								Vector2i.UP,
								location
							)
							roads.append(area)
					
					_carve_area_polygon(dungeon, area)
	
	#Generate buildings
	for building in buildings:
		var min_max = building.get_bounding_box()
		var min_x = min_max.min_x
		var max_x = min_max.max_x
		var min_y = min_max.min_y
		var max_y = min_max.max_y
		
		#var canPlaceStairs: bool = building.building_height > 0
		for floor: int in building.building_height + 1:
			var new_floor = Floor.new(building.polygon.polygon, Vector3i(building.position.x, building.position.y, floor))
			building.building_floors.append(new_floor)
			
			if floor == 0:
				_place_area(dungeon, TileConfig.tile_group_names.plot_group, min_x, min_y, floor)
			else:
				_place_area(dungeon, TileConfig.tile_group_names.building_floor_group, min_x, min_y, floor)
			
			#if floor + 1 <= building.building_height && placed:
				#dungeon.entities.append(stairs)
				#new_floor.set_stair_location(stair_location)
				#
				##Create down stairs entity above
				#stair_location = Vector3i(stair_location.x, stair_location.y, stair_location.z + 1)
				#stairs = Entity.new(dungeon, stair_location, stairs_down_definition)
				#dungeon.entities.append(stairs)
			
			_place_entities(dungeon, new_floor)
	
	_place_player(dungeon, player)
	
	#for y: int in map_height:
		#for x: int in map_width:
			#_carve_tile(dungeon, x, y, 1, TileConfig.tile_names.wall_1)
	
	return dungeon

func _carve_tile(dungeon: MapDataGrid, x: int, y: int, z: int, tile_type: int = TileConfig.tile_names.air, tile_rotation: int = 0) -> void:
	var tile_position = Vector3i(x, y, z)
	var tile: TileGrid = dungeon.get_tile(tile_position)
	tile.tile_rotation = tile_rotation
	
	if dungeon.tile_config.tile_to_entity.has(tile_type):
		var entity_type = dungeon.tile_config.tile_to_entity[tile_type]
		if dungeon.tile_config.has_entity_type(entity_type):
			var entity: EntityNew = dungeon.tile_config.get_entity_definition(entity_type).instantiate()
			entity.place_entity(tile_position)
			dungeon.entities.append(entity)
		
	else:
		if dungeon.tile_config.has_tile_type(tile_type):
			tile.set_tile_type(dungeon.tile_config.get_tile_defininition(tile_type))
		else:
			tile.set_tile_type(dungeon.tile_config.get_tile_defininition(TileConfig.tile_names.air))

func _carve_area_polygon(dungeon, area) -> void:
	var area_name = area.name
	var min_max = area.get_bounding_box()
	var min_x = min_max.min_x
	var _max_x = min_max.max_x
	var min_y = min_max.min_y
	var _max_y = min_max.max_y
	var z = area.position.z
	
	if area_name == 'Plot':
		if _rng.randf() < 0.3:
			_place_area(dungeon, TileConfig.tile_group_names.park_group, min_x, min_y, z)
			var park = Park.new(
				area.polygon.polygon,
				area.position
			)
			parks.append(park)
		else:
			var building = Building.new(
				area.polygon.polygon,
				area.position
			)
			buildings.append(building)
		#_place_area(dungeon, TileConfig.tile_group_names.plot_group, min_x, min_y, z)
	
	if area_name == 'Road':
		if area.direction == Vector2i.ZERO:
			_place_area(dungeon, TileConfig.tile_group_names.center_road_group, min_x, min_y, z)
		if area.direction == Vector2i.UP || area.direction == Vector2i.DOWN:
			_place_area(dungeon, TileConfig.tile_group_names.vertical_road_group, min_x, min_y, z)
		if area.direction == Vector2i.LEFT || area.direction == Vector2i.RIGHT:
			_place_area(dungeon, TileConfig.tile_group_names.horizontal_road_group, min_x, min_y, z)

func _place_area(dungeon: MapDataGrid, tile_group_name: int, min_x: int, min_y: int, z: int) -> void:
	var tile_group_reference: PackedScene
	if dungeon.tile_config.has_tile_group(tile_group_name):
		tile_group_reference = dungeon.tile_config.get_tile_group(tile_group_name)
	else: tile_group_reference = dungeon.tile_config.get_tile_group(TileConfig.tile_group_names.plot_group)
	
	var tile_group_temp: TileMap = tile_group_reference.instantiate()
	var ref_rect: Rect2 = tile_group_temp.get_used_rect()
	
	for x in ref_rect.size.x:
		for y in ref_rect.size.y:
			var atlasCoords: Vector2i = tile_group_temp.get_cell_atlas_coords(0, Vector2(x, y))
			var alternative_tile: int = tile_group_temp.get_cell_alternative_tile(0, Vector2(x, y), false)
			var tileType: int
			if dungeon.tile_config.has_atlas_type(atlasCoords):
				if dungeon.tile_config.has_tile_type(tileType):
					tileType = dungeon.tile_config.tile_atlas_to_type[atlasCoords]
			else:
				tileType = TileConfig.tile_names.grass_1
			
			_carve_tile(dungeon, min_x + x, min_y+ y, z, tileType, alternative_tile)
	
	tile_group_temp.queue_free()

func _place_player(dungeon: MapDataGrid, player: EntityNew) -> void:
	var randomPlot = buildings.pick_random()
	var min_max = randomPlot.get_bounding_box()
	var min_x = min_max.min_x
	var max_x = min_max.max_x
	var min_y = min_max.min_y
	var max_y = min_max.max_y
	
	var x: int = (min_x + max_x) / 2
	var y: int = (min_y + max_y) / 2
	
	dungeon.entities.append(player)
	player.place_entity(Vector3i(x, y, randomPlot.position.z))
	player.map_data = dungeon

func _place_entities(dungeon: MapDataGrid, room: Floor) -> void:
	var number_of_monsters: int = _rng.randi_range(0, max_monsters_per_room)
	var min_max = room.get_bounding_box()
	var min_x = min_max.min_x
	var max_x = min_max.max_x
	var min_y = min_max.min_y
	var max_y = min_max.max_y
	var z = room.position.z
	
	var max_tries = 10  # Maximum number of attempts to place an entity

	for _i in number_of_monsters:
		var placed = false
		var new_entity_position: Vector3i
		for _try in max_tries:
			var x: int = _rng.randi_range(min_x + 2, max_x - 2)
			var y: int = _rng.randi_range(min_y + 2, max_y - 2)
			new_entity_position = Vector3i(x, y, z)

			var can_place = true
			for entity in dungeon.entities:
				if entity.grid_position == new_entity_position:
					can_place = false
					break

			if can_place:
				var new_entity: EntityNew
				#new_entity = Entity.new(dungeon, new_entity_position, enemy_definition)
				new_entity = TileConfig.entity_definition[TileConfig.entity_names.enemy].instantiate()
				new_entity.place_entity(new_entity_position)
				dungeon.entities.append(new_entity)
				placed = true
				break  # Exit the retry loop since the entity has been placed

		if not placed:
			# Optional: Handle the case where the entity couldn't be placed after max_tries
			print("Could not place entity after max tries at position:", new_entity_position)
	
	#for _i in number_of_monsters:
		#var x: int = _rng.randi_range(min_x + 2, max_x - 2)
		#var y: int = _rng.randi_range(min_y + 2, max_y - 2)
		#var new_entity_position := Vector3i(x, y, z)
		#
		#var can_place = true
		#for entity in dungeon.entities:
			#if entity.grid_position == new_entity_position:
				#can_place = false
				#break
		#
		#if can_place:
			#var new_entity: Entity
			#new_entity = Entity.new(dungeon, new_entity_position, enemy_definition)
			##if _rng.randf() < 0.8:
				##new_entity = Entity.new(new_entity_position, entity_types.orc)
			##else:
				##new_entity = Entity.new(new_entity_position, entity_types.troll)
			#dungeon.entities.append(new_entity)
