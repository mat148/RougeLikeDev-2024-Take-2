class_name DungeonGenerator3D
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 30
@export var map_height: int = 30
@export var map_depth: int = 8

@export_category("Rooms RNG")
@export var max_rooms: int = 30
@export var room_max_size: int = 4
@export var room_min_size: int = 2

var _rng := RandomNumberGenerator.new()

@export var rooms: Array[Room3D] = []

func _ready() -> void:
	_rng.randomize()

func generate_dungeon(player: Entity3D) -> MapData3D:
	var dungeon := MapData3D.new(map_width, map_height, map_depth)
	
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		var room_depth: int = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(1, dungeon.width - room_width - 2)
		var y: int = _rng.randi_range(1, dungeon.height - room_height - 2)
		var z: int = _rng.randi_range(1, dungeon.depth - room_depth - 2)
		
		var new_room := Room3D.new(Vector3(x, y, z), room_width, room_height, room_depth)
		
		var has_intersections := false
		for room in rooms:
			# Rect2i.intersects() checks for overlapping points. In order to allow bordering rooms one room is shrunk.
			if room.intersects(new_room.grow(-1)):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		_carve_room(dungeon, new_room)
		
		if rooms.is_empty():
			player.grid_position = new_room.get_center()
		else:
			_tunnel_between(dungeon, rooms.back().get_center(), new_room.get_center())
		
		rooms.append(new_room)
	
	return dungeon

func _carve_room(dungeon: MapData3D, room: Room3D) -> void:
	var start_position: Vector3 = room.room_position
	var end_position: Vector3 = room.end

	for z in range(start_position.z, end_position.z):
		for y in range(start_position.y, end_position.y):
			for x in range(start_position.x, end_position.x):
				_carve_tile(dungeon, x, y, z)
 
func _carve_tile(dungeon: MapData3D, x: int, y: int, z: int) -> void:
	var tile_position = Vector3i(x, y, z)
	var tile: Tile3D = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types.floor)

func _tunnel_horizontal(dungeon: MapData3D, y: int, start: Vector3i, end: Vector3i) -> void:
	var x_min: int = mini(start.x, end.x)
	var x_max: int = maxi(start.x, end.x)
	for x in range(x_min, x_max + 1):
		_carve_tile(dungeon, x, y, end.z)

func _tunnel_vertical(dungeon: MapData3D, x: int, start: Vector3i, end: Vector3i) -> void:
	var y_min: int = mini(start.y, end.y)
	var y_max: int = maxi(start.y, end.y)
	for y in range(y_min, y_max + 1):
		_carve_tile(dungeon, x, y, end.z)

func _tunnel_between(dungeon: MapData3D, start: Vector3i, end: Vector3i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(dungeon, start.y, start, end)
		_tunnel_vertical(dungeon, end.x, start, end)
	else:
		_tunnel_vertical(dungeon, start.x, start, end)
		_tunnel_horizontal(dungeon, end.y, start, end)
