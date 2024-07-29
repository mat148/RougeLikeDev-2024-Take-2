extends Node

@export var map_width: int = 81
@export var map_height: int = 45

var numRoomTries: int = 80

# Increasing this allows rooms to be larger.
var roomExtraSize: int = 0

# For each open position in the dungeon, the index of the connected region
# that that position is a part of.
var _rooms: Array[Rect2i] = []

var dungeon: MapData

var Directions = [
	Vector2i(0, -1), #UP
	Vector2i(1, 0), #RIGHT
	Vector2i(0, 1), #DOWN
	Vector2i(-1, 0) #LEFT
]

# The index of the current region being carved.
var _currentRegion: int = -1

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()

func generate_dungeon(start_pos) -> MapData:
	if map_width % 2 == 0 || map_height % 2 == 0:
		printerr("The stage must be odd-sized.")
		return
	
	dungeon = MapData.new(map_width, map_height)
	get_parent().map_data = dungeon
	get_parent()._place_tiles()
	
	await _addRooms()
	
	for y in range(1, dungeon.height, 2):
		for x in range(1, dungeon.width, 2):
			var pos = Vector2i(x, y)
			if (!dungeon.get_tile(pos).is_walkable()):
				await generate_maze(pos)
	
	return dungeon

func generate_maze(start_pos) -> void:
	var stack = [start_pos]
	await _carve_tile(Vector2i(start_pos.x, start_pos.y), 0.03, 'tree')
	
	while stack.size() > 0:
		var current_pos = stack[stack.size() - 1]
		var shuffled_directions = Directions.duplicate()
		shuffled_directions.shuffle()

		var moved = false

		for direction in shuffled_directions:
			var next_pos = current_pos + direction * 2
			if is_within_bounds(next_pos) and !dungeon.tiles[next_pos.x][next_pos.y].is_walkable():
				var between_pos = current_pos + direction
				await _carve_tile(Vector2i(between_pos.x, between_pos.y), 0.03, 'tree')
				await _carve_tile(Vector2i(next_pos.x, next_pos.y), 0.03, 'tree')
				stack.append(next_pos)
				moved = true
				break

			if not moved:
				stack.pop_back()

func _addRooms() -> void:
	for i in range(0, numRoomTries):
		# Pick a random room size. The funny math here does two things:
		# - It makes sure rooms are odd-sized to line up with maze.
		# - It avoids creating rooms that are too rectangular: too tall and
		#   narrow or too wide and flat.
		# TODO: This isn't very flexible or tunable. Do something better here.
		var size = _rng.randi_range(1, 3 + roomExtraSize) * 2 + 1
		var rectangularity = _rng.randi_range(0, 1 + size / 2) * 2
		var width = size
		var height = size
		
		if _rng.randi_range(1, 2) == 1:
			width += rectangularity
		else:
			height += rectangularity
		
		var x: int = _rng.randi_range(0, dungeon.width - width - 1)
		var y: int = _rng.randi_range(0, dungeon.height - height - 1)
		var new_room = Rect2i(x, y, width, height);
		
		var has_intersections := false
		for room in _rooms:
			if room.intersects(new_room):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		_rooms.append(new_room)
		
		_startRegion()
		
		await _carve_room(dungeon, new_room)

func _carve_room(dungeon: MapData, room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			await _carve_tile(Vector2i(x, y), 0.001)

func _startRegion() -> void:
	_currentRegion += 1

func is_within_bounds(pos) -> bool:
	return pos.x > 0 and pos.x < map_width - 1 and pos.y > 0 and pos.y < map_height - 1

func _carve_tile(tile_position: Vector2i, speed: float, type: String = 'floor') -> void:
	var tile_type = dungeon.tile_types[type]
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(tile_type)
	
	#if type == 'tree':
		#tile.is_walkway = true
	#_regions[dungeon.grid_to_index(tile_position)] = _currentRegion
	
	if speed > 0:
		await Global.wait(speed)

# Gets whether or not an opening can be carved from the given starting
# [Cell] at [pos] to the adjacent Cell facing [direction]. Returns `true`
# if the starting Cell is in bounds and the destination Cell is filled
# (or out of bounds).</returns>
func _canCarve(cell: Vector2i, dir_to_cell_neighbor: Vector2i) -> bool:
	var Direction = [
		Vector2i(0, -1), #UP
		Vector2i(1, -1), #UP & RIGHT
		Vector2i(1, 0), #RIGHT
		Vector2i(1, 1), #RIGHT & DOWN
		Vector2i(0, 1), #DOWN
		Vector2i(-1, 1), #DOWN & LEFT
		Vector2i(-1, 0), #LEFT
		Vector2i(-1, -1) #LEFT & UP
	]
	
	#check is cell is inside the dungeon
	if !dungeon.area.grow(-1).has_point(cell + dir_to_cell_neighbor): return false
	#return !dungeon.get_tile(cell + dir_to_cell_neighbor * 2).is_walkable()
	
	#check in 8 directions around cell
	#except cell?
	for dir in Direction:
		var tile_vector = cell + dir_to_cell_neighbor + dir
		
		#if tile_vector != cell:
		var tile = dungeon.get_tile(tile_vector)
		if !dungeon.area.grow(0).has_point(tile_vector):
			return false
		if tile.is_walkable() && !tile.is_walkway:
			return false
	
	return true
	
	#Look around new position for walkable area
	
	#TODO modify to check if this is a wall
	#var tile = dungeon.get_tile(pos + direction * 2)
	#return !tile.is_walkable()
