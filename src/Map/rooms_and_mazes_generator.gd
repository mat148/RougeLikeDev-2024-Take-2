##Original code by Bob Nystrom in Dart
#Article: https://journal.stuffwithstuff.com/2014/12/21/rooms-and-mazes/
#Dart code: https://github.com/munificent/hauberk/blob/db360d9efa714efb6d937c31953ef849c7394a39/lib/src/content/dungeon.dart

class_name RoomsAndMazes
extends Node

@export var map_width: int = 81
@export var map_height: int = 45

var numRoomTries: int = 80

# The inverse chance of adding a connector between two regions that have
# already been joined. Increasing this leads to more loosely connected
# dungeons.
var extraConnectorChance: int = 20

# Increasing this allows rooms to be larger.
var roomExtraSize: int = 0

var windingPercent: float = 0.3

var dungeon: MapData

# For each open position in the dungeon, the index of the connected region
# that that position is a part of.
var _rooms: Array[Rect2i] = []

var _regions: Array[int] = []

# The index of the current region being carved.
var _currentRegion: int = -1

var _rng := RandomNumberGenerator.new()

var tile_size: int = 0

func _ready() -> void:
	_rng.randomize()

func generate_dungeon(player, new_tile_size) -> MapData:
	tile_size = new_tile_size
	if map_width % 2 == 0 || map_height % 2 == 0:
		printerr("The stage must be odd-sized.")
		return
	
	dungeon = MapData.new(map_width, map_height)
	get_parent().map_data = dungeon
	get_parent()._place_tiles()
	
	await _addRooms()
	
	#get_parent().map_data = dungeon
	#get_parent()._place_tiles()
	
	# Fill in all of the empty space with mazes.
	for y in range(1, dungeon.height):
		for x in range(1, dungeon.width):
			var pos = Vector2i(x, y)
			
			#TODO check if tile is a wall
			if (!dungeon.get_tile(pos).is_walkable()):
				await _growMaze(pos)

	#_connectRegions();
	#_removeDeadEnds();
#
	#_rooms.forEach(onDecorateRoom);
	
	return dungeon

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

func _startRegion() -> void:
	_currentRegion += 1

# Implementation of the "growing tree" algorithm from here:
# http://www.astrolog.org/labyrnth/algrithm.htm.


func _growMaze(start: Vector2i) -> void:
	var cells: Array[Vector2i] = []
	
	#Can we carve start?
	if _canCarve(start, Vector2.ZERO):
		await _carve_tile(start, 0.03, 'tree')
		cells.append(start);
	
	while !cells.is_empty():
		var cell = cells.back()
		var lastDir
		
		print('cell: ', cell)
		
		# See which adjacent cells are open.
		var unmadeCells: Array[Vector2i] = [];

		var Direction = [
			Vector2i(0, -1), #UP
			Vector2i(1, 0), #RIGHT
			Vector2i(0, 1), #DOWN
			Vector2i(-1, 0) #LEFT
		]
		for dir in Direction:
			if (_canCarve(cell, dir)):
				unmadeCells.append(dir)
				#cells.append(cell + dir)
				#await _carve_tile(cell + dir, 0.03, 'tree')
		
		if !unmadeCells.is_empty():
			 #Based on how "windy" passages are, try to prefer carving in the
			 #same direction.
			
			var move_dir = unmadeCells[_rng.randi_range(0, unmadeCells.size() - 1)]
			#if lastDir && unmadeCells.has(lastDir) && _rng.randf() > windingPercent:
				#move_dir = lastDir
			#else:
				#move_dir = unmadeCells[_rng.randi_range(0, unmadeCells.size() - 1)]
				#print('move direction: ', move_dir)
			
			var cell_to_carve = cell + move_dir
			print('carve cell: ', cell_to_carve)
			await _carve_tile(cell_to_carve, 0.03, 'tree')
			#cell_to_carve = cell + move_dir * 2
			#print('carve cell 2: ', cell_to_carve)
			#await _carve_tile(cell_to_carve, 0.03, 'tree')
			
			cells.append(cell + move_dir);
			lastDir = cell
		else:
			# No adjacent uncarved cells.
			cells.pop_back()
#
			# This path has ended.
			lastDir = null
		


#func _growMaze(start: Vector2i) -> void:
	#var cells: Array[Vector2i] = []
	#var lastDir
	#
	#print('start: ', start)
#
	#_startRegion();
	#if _canCarve(start, Vector2.ZERO):
		#await _carve_tile(start, 0.03, 'tree')
		#cells.append(start);
	#
	#while !cells.is_empty():
		#var cell = cells.back()
		#print('cell: ', cell)
#
		## See which adjacent cells are open.
		#var unmadeCells: Array[Vector2i] = [];
#
		#var Direction = [
			#Vector2i(0, -1), #UP
			##Vector2i(1, -1), #UP & RIGHT
			#Vector2i(1, 0), #RIGHT
			##Vector2i(1, 1), #RIGHT & DOWN
			#Vector2i(0, 1), #DOWN
			##Vector2i(-1, 1), #DOWN & LEFT
			#Vector2i(-1, 0) #LEFT
		#]
		#for dir in Direction:
			#if (_canCarve(cell, dir)): unmadeCells.append(dir)
				##cells.append(cell + dir)
		#
		#if !unmadeCells.is_empty():
			 ##Based on how "windy" passages are, try to prefer carving in the
			 ##same direction.
			#
			#var move_dir
			#if lastDir && unmadeCells.has(lastDir) && _rng.randf() > windingPercent:
				#move_dir = lastDir
			#else:
				#move_dir = unmadeCells[_rng.randi_range(0, unmadeCells.size() - 1)]
				#print('move direction: ', move_dir)
			#
			#var cell_to_carve = cell + move_dir
			#print('carve cell 1: ', cell_to_carve)
			#await _carve_tile(cell_to_carve, 0.03, 'tree')
			##cell_to_carve = cell + move_dir * 2
			##print('carve cell 2: ', cell_to_carve)
			##await _carve_tile(cell_to_carve, 0.03, 'tree')
			#
			#cells.append(cell + move_dir * 2);
			#lastDir = cell
		#else:
			## No adjacent uncarved cells.
			#cells.pop_back()
##
			## This path has ended.
			#lastDir = null

func _carve_tile(tile_position: Vector2i, speed: float, type: String = 'floor') -> void:
	var tile_type = dungeon.tile_types[type]
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(tile_type)
	#_regions[dungeon.grid_to_index(tile_position)] = _currentRegion
	
	if speed > 0:
		await Global.wait(speed)

func _carve_room(dungeon: MapData, room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			await _carve_tile(Vector2i(x, y), 0.000001)

#func _canCarve(pos: Vector2i, direction: Vector2) -> bool:
	## Must end in bounds.
	#if (!bounds.contains(pos + direction * 3)) return false;
#
	## Destination must not be open.
	#return getTile(pos + direction * 2) == Tiles.wall;

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
	return !dungeon.get_tile(cell + dir_to_cell_neighbor * 2).is_walkable()
	
	#check in 8 directions around cell
	#except cell?
	#for dir in Direction:
		#var tile_vector = cell + dir_to_cell_neighbor + dir
		#
		#if tile_vector != cell:
			#var tile = dungeon.get_tile(tile_vector)
			#if !dungeon.area.grow(0).has_point(tile_vector):
				#return false
			#if tile.is_walkable():
				#return false
	#
	#return true
	
	#Look around new position for walkable area
	
	#TODO modify to check if this is a wall
	#var tile = dungeon.get_tile(pos + direction * 2)
	#return !tile.is_walkable()
