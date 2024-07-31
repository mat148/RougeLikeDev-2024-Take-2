extends Node

@export var map_width: int = 81
@export var map_height: int = 45

var numRoomTries: int = 80

# Increasing this allows rooms to be larger.
var roomExtraSize: int = 0

# For each open position in the dungeon, the index of the connected region
# that that position is a part of.
var _rooms: Array[Rect2i] = []

var _regions: Array[Array] = []

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
	
	for x in range(0, map_width, 1):
		_regions.append([])
		for y in range(0, map_height, 1):
			_regions[x].append(0)

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
	
	_connectRegions()
	#_removeDeadEnds()
#
	#_rooms.forEach(onDecorateRoom)
	
	return dungeon

func generate_maze(start_pos) -> void:
	var stack = []
	if _canCarve(start_pos, Vector2.ZERO):
		await _carve_tile(Vector2i(start_pos.x, start_pos.y), 0.03, 'tree')
		stack = [start_pos]
	
	while stack.size() > 0:
		var current_pos = stack.back()
		var shuffled_directions = Directions.duplicate()
		shuffled_directions.shuffle()

		var moved = false

		for direction in shuffled_directions:
			var next_pos = current_pos + direction * 2
			if _canCarve(current_pos, direction):
				var between_pos = current_pos + direction
				await _carve_tile(Vector2i(between_pos.x, between_pos.y), 0.03, 'tree')
				await _carve_tile(Vector2i(next_pos.x, next_pos.y), 0.03, 'tree')
				stack.append(next_pos)
				moved = true
				break

			if not moved:
				stack.pop_back()

func _connectRegions() -> void:
	# Find all of the tiles that can connect two (or more) regions.
	var connectorRegions = [[]]
	
	for y in range(1, dungeon.height - 1, 1):
		for x in range(1, dungeon.width - 1, 1):
			var pos = Vector2i(x, y)
			
			# Can't already be part of a region.
			if dungeon.get_tile(pos).is_walkable(): continue

			var regions: Array[int] = []
			for dir in Directions:
				var posDir = pos + dir
				var region = _regions[posDir.x][posDir.y]
				if region != null: regions.append(region)

			if regions.size() < 2: continue

			connectorRegions[pos.x][pos.y] = regions

	var connectors = connectorRegions.keys()
#
	## Keep track of which regions have been merged. This maps an original
	## region index to the one it has been merged to.
	#var merged = {}
	#var openRegions: Dictionary = {}
	#for i in range(0, _currentRegion, 1):
		#merged[i] = i;
		#openRegions.append(i);

	# Keep connecting regions until we're down to one.
	#while (openRegions.length > 1) {
		#var connector = rng.item(connectors);
#
		## Carve the connection.
		#_addJunction(connector);
#
		## Merge the connected regions. We'll pick one region (arbitrarily) and
		## map all of the other regions to its index.
		#var regions = connectorRegions[connector].map((region) => merged[region]);
		#var dest = regions.first;
		#var sources = regions.skip(1).toList();
#
		## Merge all of the affected regions. We have to look at *all* of the
		## regions because other regions may have previously been merged with
		## some of the ones we're merging now.
		#for (var i = 0; i <= _currentRegion; i++) {
			#if (sources.contains(merged[i])) {
			#merged[i] = dest;
		#}
	#}
#
	## The sources are no longer in use.
	#openRegions.removeAll(sources);
#
	## Remove any connectors that aren't needed anymore.
	#connectors.removeWhere((pos) {
	## Don't allow connectors right next to each other.
	#if (connector - pos < 2) return true;
#
	## If the connector no long spans different regions, we don't need it.
	#var regions = connectorRegions[pos].map((region) => merged[region]).toSet();
#
	#if (regions.length > 1) return false;
#
	## This connecter isn't needed, but connect it occasionally so that the
	## dungeon isn't singly-connected.
	#if (rng.oneIn(extraConnectorChance)) _addJunction(pos);
#
	#return true;
	#});
	#}
	#}

func _addRooms() -> void:
	for i in range(0, numRoomTries):
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

func _carve_tile(tile_position: Vector2i, speed: float, type: String = 'floor') -> void:
	var tile_type = dungeon.tile_types[type]
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(tile_type)
	
	_regions[tile_position.x][tile_position.y] = _currentRegion
	
	if speed > 0:
		await Global.wait(speed)

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
	if !dungeon.area.grow(-1).has_point(cell + dir_to_cell_neighbor * 3): return false
	
	#check in 8 directions around cell
	#except cell?
	for dir in Direction:
		var tile_vector = (cell + dir_to_cell_neighbor * 2) + dir
		
		var tile = dungeon.get_tile(tile_vector)
		if !dungeon.area.grow(0).has_point(tile_vector):
			return false
		if tile.is_walkable():
			return false
	
	return true
