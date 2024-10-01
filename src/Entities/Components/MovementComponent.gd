extends Node2D
class_name MovementComponent

@export var parent: Entity

func move(move_offset: Vector3i) -> void:
	var map_data: MapDataGrid = parent.map_data
	
	map_data.unregister_blocking_entity(parent)
	parent.grid_position += move_offset
	map_data.register_blocking_entity(parent)

