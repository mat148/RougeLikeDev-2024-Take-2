extends Node3D
class_name Room3D

@export var height: int
@export var width: int
@export var depth: int

@export var room_position: Vector3

@export var end: Vector3

func _init(new_position: Vector3, room_height: int, room_width: int, room_depth: int) -> void:
	height = room_height
	width = room_width
	depth = room_depth
	
	room_position = new_position
	
	end = room_position + Vector3(width, height, depth)

func intersects(room: Room3D) -> bool:
	# Check for intersection along the x-axis
	if room_position.x < room.room_position.x + room.width and room_position.x + width > room.room_position.x:
		# Check for intersection along the y-axis
		if room_position.y < room.room_position.y + room.height and room_position.y + height > room.room_position.y:
			# Check for intersection along the z-axis
			if room_position.z < room.room_position.z + room.depth and room_position.z + depth > room.room_position.z:
				return true
	return false

func grow(by_amount: int) -> Room3D:
	var new_width = width + by_amount * 2
	var new_height = height + by_amount * 2
	var new_depth = depth + by_amount * 2

	var new_position = room_position - Vector3(by_amount, by_amount, by_amount)

	var new_room = Room3D.new(new_position, new_height, new_width, new_depth)
	return new_room

func get_center() -> Vector3:
	return room_position + Vector3(width / 2.0, height / 2.0, depth / 2.0)
