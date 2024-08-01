extends Node
class_name DungeonGenerator3D

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 45
@export var map_depth: int = 9

@export_category("Rooms RNG")
@export var max_rooms: int = 30
@export var room_max_size: int = 10
@export var room_min_size: int = 6

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()

func generate_dungeon(player: Entity) -> MapData3D:
	var dungeon := MapData3D.new(map_width, map_height, map_depth)
	
	#var rooms: Array[Rect2i] = []
	#
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
