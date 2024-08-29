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

@export_category("Rooms RNG")
@export var max_rooms: int = 30
@export var room_max_size: int = 10
@export var room_min_size: int = 6

var _rng := RandomNumberGenerator.new()

var plots: Array[Plot] = []
var roads: Array[Road] = []

var plot_size = 11
var road_size = 11


func _ready() -> void:
	_rng.randomize()

func generate_dungeon() -> MapDataGrid:
	# Check if map_width and map_height are divisible by plot_size
	if map_width % (plot_size * 2) != 0:
		printerr("Error: map_width must be divisible by the plot_size of ", plot_size)
	if map_height % (plot_size * 2) != 0:
		printerr("Error: map_height must be divisible by the plot_size of ", plot_size)
	
	var dungeon := MapDataGrid.new(map_width, map_height)
	
	#Roads 11
	#Plot 10
	
	#Generate possible locations for plots
	#Pick rand location
	#Place plot
	#Pick a random direction
	#check if we can place a plot or road
	#add them to an array
	#choose a random one
		#place a plot or road
	
	var calc_plot_width = map_width/(plot_size * 2)
	var calc_plot_height = map_height/(plot_size * 2)
	
	var rand_plot_location: Vector2 = Vector2(randi_range(0, calc_plot_width - 1), randi_range(0, calc_plot_height - 1))
	rand_plot_location = rand_plot_location * (plot_size * 2)
	
	var possible_plots: Array[Plot] = []
	possible_plots.append(
		Plot.new(
			[
				rand_plot_location,
				Vector2i(rand_plot_location.x + plot_size, rand_plot_location.y),
				Vector2i(rand_plot_location.x + plot_size, rand_plot_location.y + plot_size),
				Vector2i(rand_plot_location.x, rand_plot_location.y + plot_size),
			],
			rand_plot_location
		)
	)
	
	#_carve_room(dungeon, possible_plots[0])
	_carve_area_polygon(dungeon, possible_plots[0])
	plots.append(possible_plots[0])
	
	#var plot_count: int = 0
	while !possible_plots.is_empty():
		var new_plot: Plot = possible_plots.pop_back()
		#plot_count += 1
		
		#random direction
		var directions_copy = directions.duplicate(true)
		while !directions_copy.is_empty():
			var options:= []
			var random_direction = directions_copy.pick_random()
			
			#Check direction plot
			#TODO check if plot_count > 4
			var possible_plot_location = new_plot.position + (random_direction * (plot_size * 2))
			var possible_plot = Plot.new(
				[
					possible_plot_location,
					Vector2i(possible_plot_location.x + plot_size, possible_plot_location.y),
					Vector2i(possible_plot_location.x + plot_size, possible_plot_location.y + plot_size),
					Vector2i(possible_plot_location.x, possible_plot_location.y + plot_size),
				],
				possible_plot_location
			)
			
			if dungeon.area.has_point(possible_plot_location):
				var has_intersections := false
				var all_objects: Array[BaseObject] = []
				all_objects.append_array(plots)
				all_objects.append_array(roads)
				
				for object in all_objects:
					if object.intersects(possible_plot):
						has_intersections = true
						break
				if !has_intersections:
					options.append(possible_plot)
			
			#TODO Check direction road
			var possible_road_location = new_plot.position + (random_direction * (plot_size))
			var possible_road = Road.new(
				[
					possible_road_location,
					Vector2i(possible_road_location.x + plot_size, possible_road_location.y),
					Vector2i(possible_road_location.x + plot_size, possible_road_location.y + plot_size),
					Vector2i(possible_road_location.x, possible_road_location.y + plot_size),
				],
				random_direction,
				possible_road_location
			)
			if dungeon.area.has_point(possible_road_location):
				var has_intersections := false
				var all_objects: Array[BaseObject] = []
				all_objects.append_array(plots)
				all_objects.append_array(roads)
				
				for object in all_objects:
					if object.intersects(possible_road):
						has_intersections = true
						break
				if !has_intersections:
					options.append(possible_road)
			
			
			if options:
				#Place plot or road
				var new_option_direction = options.pick_random()
				
				#if plot
				if new_option_direction.name == 'Plot':
					var merged_plot = new_plot.merge_objects(new_option_direction)
					var new_merged_plot = Plot.new(
						merged_plot,
						new_plot.position
					)
					plots.erase(new_plot)
					new_plot = new_merged_plot
					plots.append(new_merged_plot)
					possible_plots.append(new_option_direction)
				
				#If road
				if new_option_direction.name == 'Road':
					roads.append(new_option_direction)
				
				#_carve_room(dungeon, new_option_direction)
			
			directions_copy.erase(random_direction)
	
	for plot in plots:
		#_carve_room(dungeon, plot)
		_carve_area_polygon(dungeon, plot)
	
	for road in roads:
		#_carve_room(dungeon, road)
		_carve_area_polygon(dungeon, road)
	
	#for width in calc_plot_width:
		#for height in calc_plot_height:
			#var new_plot := Rect2i(
				#width * (plot_size * 2), 
				#height * (plot_size * 2), plot_size, plot_size
			#)
			#plots.append(new_plot)
	
	#var calc_road_width = map_width/(plot_size)
	#var calc_road_height = map_height/(plot_size)
	#
	#for width in calc_road_width:
		#for height in calc_road_height:
			#generate_road(width, height, dungeon)
	
	#for _try_room in max_rooms:
		#var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		#var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		#
		#var x: int = _rng.randi_range(0, dungeon.width - room_width - 1)
		#var y: int = _rng.randi_range(0, dungeon.height - room_height - 1)
		#
		#var new_room := Rect2i(x, y, room_width, room_height)
		#
		#var has_intersections := false
		#for room in rooms:
			## Rect2i.intersects() checks for overlapping points. In order to allow bordering rooms one room is shrunk.
			#if room.intersects(new_room.grow(-1)):
				#has_intersections = true
				#break
		#if has_intersections:
			#continue
		#
		#_carve_room(dungeon, new_room)
		#
		#if rooms.is_empty():
			#player.grid_position = new_room.get_center()
		#else:
			#_tunnel_between(dungeon, rooms.back().get_center(), new_room.get_center())
		#
		#rooms.append(new_room)

	return dungeon

#func generate_plot(width, height, dungeon) -> void:
	#var plots: Array[Rect2i] = []
	#
	#var new_plot := Rect2i(
	#width * (plot_size + road_size), 
	#height * (plot_size + road_size), plot_size, plot_size)
#
	#var has_intersections := false
	#for plot in plots:
		## Rect2i.intersects() checks for overlapping points. In order to allow bordering rooms one room is shrunk.
		#if plot.intersects(new_plot.grow(-1)):
			#has_intersections = true
			#break
	#if !has_intersections:
		#_carve_room(dungeon, new_plot)
		#plots.append(new_plot)

#func generate_road(width, height, dungeon) -> void:
	#var roads: Array[Rect2i] = []
	#
	#var new_road := Rect2i(
	#width * (plot_size + road_size), 
	#height * (plot_size + road_size), road_size, road_size)
#
	#var has_intersections := false
	#for road in roads:
		## Rect2i.intersects() checks for overlapping points. In order to allow bordering rooms one room is shrunk.
		#if road.intersects(new_road.grow(-1)):
			#has_intersections = true
			#break
	#if !has_intersections:
		#_carve_room(dungeon, new_road)
		#roads.append(new_road)

func _carve_tile(dungeon: MapDataGrid, x: int, y: int, tile_type: String = 'floor') -> void:
	var tile_position = Vector2i(x, y)
	var tile: TileGrid = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types[tile_type])

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
	
	if area_name == 'Plot':
		for y in range(min_y, max_y + 1):
			for x in range(min_x, max_x + 1):
				var tile_pos = Vector2i(x, y)
				if area._is_point_in_polygon(tile_pos):
					_carve_tile(dungeon, x, y)
	
	if area_name == 'Road':
		if area.direction == Vector2i.UP || area.direction == Vector2i.DOWN:
			_place_horizontal_road(dungeon, min_x, max_x, min_y)
			
		if area.direction == Vector2i.LEFT || area.direction == Vector2i.RIGHT:
			_place_vertical_road(dungeon, min_y, max_y, min_x)

func _place_horizontal_road(dungeon, min_x, max_x, min_y) -> void:
	for x in range(min_x, max_x):
		_carve_tile(dungeon, x, min_y, 'tree')
		_carve_tile(dungeon, x, min_y + 1, 'tree')
		_carve_tile(dungeon, x, min_y + 2, 'wall')
		
		_carve_tile(dungeon, x, min_y + 3, 'floor')
		_carve_tile(dungeon, x, min_y + 4, 'floor')
		
		_carve_tile(dungeon, x, min_y + 5, 'tree')
		
		_carve_tile(dungeon, x, min_y + 6, 'floor')
		_carve_tile(dungeon, x, min_y + 7, 'floor')
		
		_carve_tile(dungeon, x, min_y + 8, 'wall')
		_carve_tile(dungeon, x, min_y + 9, 'tree')
		_carve_tile(dungeon, x, min_y + 10, 'tree')

func _place_vertical_road(dungeon, min_y, max_y, min_x) -> void:
	for y in range(min_y, max_y):
		_carve_tile(dungeon, min_x, y, 'tree')
		_carve_tile(dungeon, min_x + 1, y, 'tree')
		_carve_tile(dungeon, min_x + 2, y, 'wall')
		
		_carve_tile(dungeon, min_x + 3, y, 'floor')
		_carve_tile(dungeon, min_x + 4, y, 'floor')
		
		_carve_tile(dungeon, min_x + 5, y, 'tree')
		
		_carve_tile(dungeon, min_x + 6, y, 'floor')
		_carve_tile(dungeon, min_x + 7, y, 'floor')
		
		_carve_tile(dungeon, min_x + 8, y, 'wall')
		_carve_tile(dungeon, min_x + 9, y, 'tree')
		_carve_tile(dungeon, min_x + 10, y, 'tree')

func _tunnel_horizontal(dungeon: MapDataGrid, y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		_carve_tile(dungeon, x, y)

func _tunnel_vertical(dungeon: MapDataGrid, x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		_carve_tile(dungeon, x, y)

func _tunnel_between(dungeon: MapDataGrid, start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(dungeon, start.y, start.x, end.x)
		_tunnel_vertical(dungeon, end.x, start.y, end.y)
	else:
		_tunnel_vertical(dungeon, start.x, start.y, end.y)
		_tunnel_horizontal(dungeon, end.y, start.x, end.x)
