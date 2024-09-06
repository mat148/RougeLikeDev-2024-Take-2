class_name MovementAction
extends Action

var offset: Vector3i


func _init(dx: int, dy: int, dz: int) -> void:
	offset = Vector3i(dx, dy, dz)


func perform(game: GameGrid, entity: Entity) -> void:
	var destination: Vector3i = entity.grid_position + offset
	
	var map_data: MapDataGrid = game.get_map_data()
	var destination_tile: TileGrid = map_data.get_tile(destination)
	if not destination_tile or not destination_tile.is_walkable():
		return
	entity.move(offset)
	
