class_name Entity3D
extends Sprite3D

@export var entity_layer: int = 0

var grid_position: Vector3i:
	set(value):
		grid_position = value
		entity_layer = grid_position.z
		print(entity_layer)
		var world_position: Vector3 = Grid3D.grid_to_world(grid_position)
		position = Vector3(world_position.x, world_position.y, world_position.z + 0.03)

func _init(start_position: Vector3i, entity_definition: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	texture = entity_definition.texture
	modulate = entity_definition.color

func move(move_offset: Vector3i) -> void:
	grid_position += move_offset

func show_layer(current_layer: int) -> void:
	if current_layer == entity_layer:
		visible = true
	else:
		visible = false
