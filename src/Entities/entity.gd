class_name Entity
extends Sprite2D

var _definition: EntityDefinition

var grid_position: Vector3i:
	set(value):
		grid_position = value
		var grid_to_world_position = Grid.grid_to_world(grid_position)
		position = Vector2(grid_to_world_position.x, grid_to_world_position.y)

func _init(start_position: Vector3i, entity_definition: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	set_entity_type(entity_definition)

func move(move_offset: Vector3i) -> void:
	grid_position += move_offset

func set_entity_type(entity_definition: EntityDefinition) -> void:
	_definition = entity_definition
	texture = entity_definition.texture
	modulate = entity_definition.color

func is_blocking_movement() -> bool:
	return _definition.is_blocking_movement

func get_entity_name() -> String:
	return _definition.name
