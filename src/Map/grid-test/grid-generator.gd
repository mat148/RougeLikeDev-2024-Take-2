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

##ITEMS

var _rng := RandomNumberGenerator.new()

var plots: Array[Plot] = []
var buildings: Array[Building] = []
var parks: Array[Park] = []
var roads: Array[Road] = []

var plot_size: int = 11
#var road_size: int = 11


func _ready() -> void:
	_rng.randomize()

func generate_dungeon(player: Entity, world_width: int, world_height: int) -> MapDataGrid:
	plots = []
	buildings = []
	parks = []
	roads = []
	
	for child in get_children():
		child.queue_free()
	
	map_width = world_width
	map_height = world_height
	
	var building_plot_size: Vector3i = Vector3i(map_width - (plot_size * 6), map_height - (plot_size * 6), map_depth)
	var building_plot_position: Vector3i = Vector3i(plot_size * 3, plot_size * 3, 0)
	var dungeon := MapDataGrid.new(map_width, map_height, map_depth, building_plot_size, building_plot_position, player)
	
	#var calc_plot_width: int = map_width / plot_size
	#var calc_plot_height: int = map_height / plot_size
	
	## Check if map_width and map_height are divisible by plot_size
	#if map_width % (plot_size) != 0:
		#printerr("Error: map_width must be divisible by the plot_size of ", plot_size)
	#if map_height % (plot_size) != 0:
		#printerr("Error: map_height must be divisible by the plot_size of ", plot_size)
	
	var local_building = Building.new(building_plot_position, dungeon)
	#var polygon3: Polygon2D = Polygon2D.new()
	#polygon3.polygon = local_building.polygon.polygon
	buildings.append(local_building)
	#add_child(polygon3)
	#polygon3.position = Vector2(25,0)
	
	#var area = Plot.new(
		#[
			#Vector2i(0,0)
		#],
		#Vector3i(0,0,0)
	#)
	#for x in building_plot_size.x:
		#for y in building_plot_size.y:
			#_carve_tile(dungeon, area, x + building_plot_position.x, y + building_plot_position.y, 0, TileConfig.tile_names.dev)
	
	
	#Generate buildings
	##TODO Move this into the building generation?
	for building in buildings:
		for sub_area in building.sub_areas:
			if sub_area.name == 'Path':
				var min_max = sub_area.get_bounding_box()
				var min_x = min_max.min_x
				var max_x = min_max.max_x
				var min_y = min_max.min_y
				var max_y = min_max.max_y
				
				for x in range(min_x, max_x, 1):
					for y in range(min_y, max_y, 1):
						_carve_tile(dungeon, building, x, y, 0, TileConfig.tile_names.grass_4)
		
		var min_max = building.get_bounding_box()
		var min_x = min_max.min_x
		var max_x = min_max.max_x
		var min_y = min_max.min_y
		var max_y = min_max.max_y
		
		#var possible_doors: Array[Vector3i] = []
		for x in range(min_x, max_x, 1):
			for y in range(min_y, max_y, 1):
				if building._is_point_in_polygon(Vector2i(x, y)):
					#possible_doors.append(Vector3i(x, y, 0))
					_carve_tile(dungeon, building, x, y, 0, TileConfig.tile_names.wall_1)
				else:
					_carve_tile(dungeon, building, x, y, 0, TileConfig.tile_names.grass_1)
		
		
		#var edge_points: Array[Vector2] = building.get_edge_points()
		#for position in edge_points:
			#_carve_tile(dungeon, building, position.x, position.y, 0, TileConfig.tile_names.wall_1)
		
		for door in building.doors:
			_carve_tile(dungeon, building, door.x, door.y, 0, TileConfig.tile_names.door_1)
		
		#var door: Vector3i = possible_doors.pick_random()
		#_carve_tile(dungeon, building, door.x, door.y, 0, TileConfig.tile_names.door_1)
		
		#for polygon in building.polygons:
			#polygon.color = Color.from_hsv((randi() % 12) / 12.0, 1, 1)
			#add_child(polygon)
		
		##var canPlaceStairs: bool = building.building_height > 0
		#for floor: int in building.building_height + 1:
			#var new_floor = Floor.new(building, building.polygon.polygon, Vector3i(building.position.x, building.position.y, floor))
			#building.building_floors.append(new_floor)
			#
			#if floor == 0:
				#_place_area(dungeon, new_floor, TileConfig.tile_group_names.plot_group, min_x, min_y, floor)
			#else:
				#_place_area(dungeon, new_floor, TileConfig.tile_group_names.building_floor_group, min_x, min_y, floor)
			#
			#var rand_location = Vector2i(randi_range(min_x, max_x), randi_range(min_y, max_y))
			#_carve_tile(dungeon, new_floor, rand_location.x, rand_location.y, floor, TileConfig.tile_names.tree_1)
			##_place_entities(dungeon, new_floor)
	
	_place_player(dungeon, player)

	#
	#for x in 3:
		#for y in 3:
			#var location = Vector3i(x * plot_size, y * plot_size, 0)
			#if x == 1 && y == 1 || x == 2 && y == 0:
				#var local_building = Building.new(
					#[
						#Vector2i(location.x, location.y),
						#Vector2i(location.x + plot_size, location.y),
						#Vector2i(location.x + plot_size, location.y + plot_size),
						#Vector2i(location.x, location.y + plot_size),
					#],
					#location
				#)
				#buildings.append(local_building)
			#else:
				#var area = Plot.new(
					#[
						#Vector2i(location.x, location.y),
						#Vector2i(location.x + plot_size, location.y),
						#Vector2i(location.x + plot_size, location.y + plot_size),
						#Vector2i(location.x, location.y + plot_size),
					#],
					#location
				#)
				#_carve_area_polygon(dungeon, area)
	#
	##Generate buildings
	#for building in buildings:
		#var min_max = building.get_bounding_box()
		#var min_x = min_max.min_x
		#var max_x = min_max.max_x
		#var min_y = min_max.min_y
		#var max_y = min_max.max_y
		#
		##var canPlaceStairs: bool = building.building_height > 0
		#for floor: int in building.building_height + 1:
			#var new_floor = Floor.new(building, building.polygon.polygon, Vector3i(building.position.x, building.position.y, floor))
			#building.building_floors.append(new_floor)
			#
			#if floor == 0:
				#_place_area(dungeon, new_floor, TileConfig.tile_group_names.plot_group, min_x, min_y, floor)
			#else:
				#_place_area(dungeon, new_floor, TileConfig.tile_group_names.building_floor_group, min_x, min_y, floor)
			#
			#var rand_location = Vector2i(randi_range(min_x, max_x), randi_range(min_y, max_y))
			#_carve_tile(dungeon, new_floor, rand_location.x, rand_location.y, floor, TileConfig.tile_names.tree_1)
			##_place_entities(dungeon, new_floor)
	#
	#_place_player(dungeon, player)
	
	#for y: int in calc_plot_height:
		#for x: int in calc_plot_width:
			#for z: int in map_depth:
				#if z == 0:
					#var check_x: int = x % 2
					#var check_y: int = y % 2
					#
					#var location = Vector3i(x * plot_size, y * plot_size, z)
					#
					#var area
					#var points = [
						#Vector2i(location.x, location.y),
						#Vector2i(location.x + plot_size, location.y),
						#Vector2i(location.x + plot_size, location.y + plot_size),
						#Vector2i(location.x, location.y + plot_size),
					#]
					#if check_y == 1:
						#if check_x == 0:
							#area = Road.new(
								#points,
								#Vector2i.LEFT,
								#location
							#)
							#roads.append(area)
						#else:
							#area = Road.new(
								#points,
								#Vector2i.ZERO,
								#location
							#)
							#roads.append(area)
					#else:
						#if (x + y) % 2 == 0:
							#area = Plot.new(
								#points,
								#location
							#)
						#else:
							#area = Road.new(
								#points,
								#Vector2i.UP,
								#location
							#)
							#roads.append(area)
					#
					#_carve_area_polygon(dungeon, area)
	#
	##Generate buildings
	#for building in buildings:
		#var min_max = building.get_bounding_box()
		#var min_x = min_max.min_x
		#var max_x = min_max.max_x
		#var min_y = min_max.min_y
		#var max_y = min_max.max_y
		#
		##var canPlaceStairs: bool = building.building_height > 0
		#for floor: int in building.building_height + 1:
			#var new_floor = Floor.new(building, building.polygon.polygon, Vector3i(building.position.x, building.position.y, floor))
			#building.building_floors.append(new_floor)
			#
			#if floor == 0:
				#_place_area(dungeon, new_floor, TileConfig.tile_group_names.plot_group, min_x, min_y, floor)
			#else:
				#_place_area(dungeon, new_floor, TileConfig.tile_group_names.building_floor_group, min_x, min_y, floor)
			#
			##if floor + 1 <= building.building_height && placed:
				##dungeon.entities.append(stairs)
				##new_floor.set_stair_location(stair_location)
				##
				###Create down stairs entity above
				##stair_location = Vector3i(stair_location.x, stair_location.y, stair_location.z + 1)
				##stairs = Entity.new(dungeon, stair_location, stairs_down_definition)
				##dungeon.entities.append(stairs)
			#
			#_place_entities(dungeon, new_floor)
	#
	#_place_player(dungeon, player)
	#
	##for y: int in map_height:
		##for x: int in map_width:
			##_carve_tile(dungeon, x, y, 1, TileConfig.tile_names.wall_1)
	
	dungeon.setup_pathfinding()
	return dungeon

func _carve_tile(dungeon: MapDataGrid, area: BaseObject, x: int, y: int, z: int, tile_type: int = TileConfig.tile_names.air, tile_rotation: int = 0) -> void:
	var tile_position = Vector3i(x, y, z)
	var tile: TileGrid = dungeon.get_tile(tile_position)
	tile.tile_rotation = tile_rotation
	tile.parent = area
	
	if dungeon.tile_config.tile_to_entity.has(tile_type):
		var entity_type = dungeon.tile_config.tile_to_entity[tile_type]
		if dungeon.tile_config.has_entity_type(entity_type):
			if entity_type == dungeon.tile_config.entity_names.stairway_up && area.parent_building.building_height > 0 || dungeon.tile_config.entity_names.stairway_down && area.parent_building.building_height > 0:
				var blocking_entity: Entity = dungeon.get_blocking_entity_at_location(tile_position)
				if !blocking_entity:
					var stairway: Entity = dungeon.tile_config.get_entity_definition(entity_type).instantiate()
					stairway.place_entity(tile_position)
					stairway.map_data = dungeon
					stairway.floor = area
					stairway.visible = false
					#area.stairway_up_options.append(stairway)
					dungeon.entities.append(stairway)
			
			#tile.set_tile_type(dungeon.tile_config.get_tile_defininition(TileConfig.tile_names.blank))
		
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
		var park = Park.new(
			area.polygon.polygon,
			area.position
		)
		_place_area(dungeon, park, TileConfig.tile_group_names.park_group, min_x, min_y, z)
		parks.append(park)
		
		
		#if _rng.randf() < 0.3:
			#var park = Park.new(
				#area.polygon.polygon,
				#area.position
			#)
			#_place_area(dungeon, park, TileConfig.tile_group_names.park_group, min_x, min_y, z)
			#parks.append(park)
		#else:
			#var building = Building.new(
				#area.polygon.polygon,
				#area.position
			#)
			#buildings.append(building)
		#_place_area(dungeon, TileConfig.tile_group_names.plot_group, min_x, min_y, z)
	
	if area_name == 'Road':
		if area.direction == Vector2i.ZERO:
			_place_area(dungeon, area, TileConfig.tile_group_names.center_road_group, min_x, min_y, z)
		if area.direction == Vector2i.UP || area.direction == Vector2i.DOWN:
			_place_area(dungeon, area, TileConfig.tile_group_names.vertical_road_group, min_x, min_y, z)
		if area.direction == Vector2i.LEFT || area.direction == Vector2i.RIGHT:
			_place_area(dungeon, area, TileConfig.tile_group_names.horizontal_road_group, min_x, min_y, z)

func _place_area(dungeon: MapDataGrid, area: BaseObject, tile_group_name: int, min_x: int, min_y: int, z: int) -> void:
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
			
			_carve_tile(dungeon, area, min_x + x, min_y+ y, z, tileType, alternative_tile)
	
	##Generate stairs
	#if tile_group_name == TileConfig.tile_group_names.plot_group:
		#var building: Building = area.parent_building
		#var stair_options: Array[Entity] = area.stairway_up_options
		#if stair_options:
			#var level: int = area.position.z
			#if level > 0:
				##Look for the stairup on the floor below
				#var previous_floor_int: int = level - 1
				#var previous_floor: Floor = building.get_floor(previous_floor_int)
				#
				#for stairway_up in previous_floor.stair_up_locations:
					#var entity: Entity = dungeon.tile_config.get_entity_definition(dungeon.tile_config.entity_names.stairway_down).instantiate()
					#var stairway_down_location: Vector3i = Vector3i(stairway_up.x, stairway_up.y, stairway_up.z + 1)
					#entity.place_entity(stairway_down_location)
					#dungeon.entities.append(entity)
					#area.stairway_down_options.append(entity)
					#
					#for i in range(0, stair_options.size(), 1):
						#if stair_options[i].grid_position == stairway_down_location:
							#stair_options.remove_at(i)
			#
			#var random_stair = stair_options.pick_random()
			#dungeon.entities.append(random_stair)
			#area.stair_up_locations.append(random_stair)
			#stair_options.clear()
		
			##Setup next floor's down stair
			#var entity: Entity = dungeon.tile_config.get_entity_definition(dungeon.tile_config.entity_names.stairway_down).instantiate()
			#var stair_up_position: Vector3i = random_stair.grid_position
			#entity.place_entity(Vector3i(stair_up_position.x, stair_up_position.y, stair_up_position.z + 1))
			#dungeon.entities.append(entity)
			#var building: Building = area.parent_building
			#var next_floor = building.get_floor(area.position.z + 1)
			#next_floor.stairway_down_options.append(entity)
	
	tile_group_temp.queue_free()

func _place_player(dungeon: MapDataGrid, player: Entity) -> void:
	#var randomPlot = buildings.pick_random()
	#var min_max = randomPlot.get_bounding_box()
	#var min_x = min_max.min_x
	#var max_x = min_max.max_x
	#var min_y = min_max.min_y
	#var max_y = min_max.max_y
	#
	#var x: int = (min_x + max_x) / 2
	#var y: int = (min_y + max_y) / 2
	
	var building: Building = buildings[0]
	var min_max = building.get_bounding_box()
	var min_x = min_max.min_x
	var max_x = min_max.max_x
	var min_y = min_max.min_y
	var max_y = min_max.max_y
	
	#var x: int = (min_x + max_x) / 2
	#var y: int = (min_y + max_y) / 2
	
	dungeon.entities.append(player)
	player.place_entity(Vector3i(min_x - 5, min_y - 5, 0))
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
				var new_entity: Entity
				#new_entity = Entity.new(dungeon, new_entity_position, enemy_definition)
				new_entity = TileConfig.entity_definition[TileConfig.entity_names.enemy].instantiate()
				new_entity.visible = false
				new_entity.place_entity(new_entity_position)
				new_entity.map_data = dungeon
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
