class_name Grid3D
extends Object

const tile_size = 0.16


static func grid_to_world(grid_pos: Vector3i) -> Vector3:
	var world_pos: Vector3 = grid_pos * tile_size
	return world_pos


static func world_to_grid(world_pos: Vector3i) -> Vector3i:
	var grid_pos: Vector3i = world_pos / tile_size
	return grid_pos
