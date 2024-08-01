class_name Grid3D
extends Object

const tile_size = Vector3i(16, 16, 16)


static func grid_to_world(grid_pos: Vector3i) -> Vector3i:
	var world_pos: Vector3i = grid_pos * tile_size
	return world_pos


static func world_to_grid(world_pos: Vector3i) -> Vector3i:
	var grid_pos: Vector3i = world_pos / tile_size
	return grid_pos
