class_name Entity
extends Sprite2D

var grid_position: Vector3i:
	set(value):
		grid_position = value
		var grid_to_world_position = Grid.grid_to_world(grid_position)
		position = Vector2(grid_to_world_position.x, grid_to_world_position.y)

func _init(start_position: Vector3i, entity_definition: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	texture = entity_definition.texture
	modulate = entity_definition.color

func move(move_offset: Vector3i) -> void:
	grid_position += move_offset
