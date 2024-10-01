extends Node2D
class_name AIComponent

@export var parent: Entity

var path: Array = []

func get_point_path_to(destination: Vector3i) -> PackedVector2Array:
	var map_data: MapDataGrid = parent.map_data
	var converted_entity_position: Vector2i = Vector2i(parent.grid_position.x, parent.grid_position.y)
	var converted_destination: Vector2i = Vector2i(destination.x, destination.y)
	return map_data.pathfinder.get_point_path(converted_entity_position, converted_destination)

func perform() -> void:
	var map_data: MapDataGrid = parent.map_data
	var target: Entity = map_data.player
	var target_grid_position: Vector3i = target.grid_position
	var offset: Vector3i = target_grid_position - parent.grid_position
	var distance: int = max(abs(offset.x), abs(offset.y), abs(offset.z))
	
	if map_data.get_tile(parent.grid_position).is_in_view:
		if distance <= 1:
			return MeleeAction.new(parent, offset.x, offset.y, offset.z).perform()
		
		path = get_point_path_to(target_grid_position)
		path.pop_front()
	
	if not path.is_empty():
		var destination := Vector3i(path[0])
		if map_data.get_blocking_entity_at_location(destination):
			return WaitAction.new(parent).perform()
		path.pop_front()
		var move_offset: Vector3i = destination - parent.grid_position
		return MovementAction.new(parent, move_offset.x, move_offset.y, move_offset.z).perform()
	
	return WaitAction.new(parent).perform()
