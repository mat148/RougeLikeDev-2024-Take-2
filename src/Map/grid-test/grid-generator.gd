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
@export var map_depth: int = 11

@export_category("Rooms RNG")
@export var max_rooms: int = 30
@export var room_max_size: int = 10
@export var room_min_size: int = 6

var _rng := RandomNumberGenerator.new()

var plots: Array[Plot] = []
var roads: Array[Road] = []

var plot_size: int = 11
var road_size: int = 11


func _ready() -> void:
	_rng.randomize()

func generate_dungeon(player: Entity) -> MapDataGrid:
	# Check if map_width and map_height are divisible by plot_size
	if map_width % (plot_size) != 0:
		printerr("Error: map_width must be divisible by the plot_size of ", plot_size)
	if map_height % (plot_size) != 0:
		printerr("Error: map_height must be divisible by the plot_size of ", plot_size)
	
	var dungeon := MapDataGrid.new(map_width, map_height, map_depth)
	
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
						else:
							area = Road.new(
								points,
								Vector2i.ZERO,
								location
							)
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
					
					_carve_area_polygon(dungeon, area)
	
	for x in map_width:
		_carve_tile(dungeon, x, 0, 1, TileConfig.tile_names.wall_1)
	
	return dungeon

func _carve_tile(dungeon: MapDataGrid, x: int, y: int, z: int, tile_type: int = TileConfig.tile_names.air, tile_rotation: int = 0) -> void:
	var tile_position = Vector3i(x, y, z)
	var tile: TileGrid = dungeon.get_tile(tile_position)
	tile.tile_rotation = tile_rotation
	if dungeon.tile_config.has_tile_type(tile_type):
		tile.set_tile_type(dungeon.tile_config.get_tile_defininition(tile_type))
	else:
		tile.set_tile_type(dungeon.tile_config.get_tile_defininition(TileConfig.tile_names.air))

#func _carve_room(dungeon: MapDataGrid, room) -> void:
	#var plot: Rect2i = room.rect2D
	#var inner: Rect2i = plot.grow(-1)
	#for y in range(plot.position.y, plot.end.y + 1):
		#for x in range(plot.position.x, plot.end.x + 1):
			#_carve_tile(dungeon, x, y)

func _carve_area_polygon(dungeon, area) -> void:
	var area_name = area.name
	var min_max = area.get_bounding_box()
	var min_x = min_max.min_x
	var max_x = min_max.max_x
	var min_y = min_max.min_y
	var max_y = min_max.max_y
	var z = area.position.z
	
	if area_name == 'Plot':
		_place_area(dungeon, TileConfig.tile_group_names.plot_group, min_x, min_y, z)
	
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
				tileType = dungeon.tile_config.tile_atlas_to_type[atlasCoords]
			else:
				tileType = TileConfig.tile_names.grass_1
			
			_carve_tile(dungeon, min_x + x, min_y+ y, z, tileType, alternative_tile)
	
	tile_group_temp.queue_free()
