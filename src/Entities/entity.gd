class_name Entity
extends Node2D

#var _definition: EntityDefinition
@export var entity_name: String = ""
var map_data: MapDataGrid
@export var _is_blocking_movement: bool = false

var grid_position: Vector3i:
	set(value):
		grid_position = value
		var grid_to_world_position = Grid.grid_to_world(grid_position)
		position = Vector2(grid_to_world_position.x, grid_to_world_position.y)

var has_seen: bool = false

var is_in_view: bool = false:
	set(value):
		is_in_view = value
		if is_in_view:
			has_seen = true
		
		if has_seen && grid_position.z == map_data.current_layer:
			visible = true
			if self.is_in_group("actors"):
				visible = is_in_view
			else:
				modulate = Color(1, 1, 1, 1 if is_in_view else 0.3)
		else: visible = false

#func _init(map_data: MapDataGrid, start_position: Vector3i, entity_definition: EntityDefinition) -> void:
	#visible = false
	#grid_position = start_position
	#self.map_data = map_data
	#set_entity_type(entity_definition)

#func set_entity_type(entity_definition: EntityDefinition) -> void:
	#_definition = entity_definition

func is_blocking_movement() -> bool:
	return _is_blocking_movement

func get_entity_name() -> String:
	return entity_name

func move(offset: Vector3i) -> void:
	printerr('Missing Movement Component on: ', entity_name)

func place_entity(new_position: Vector3i) -> void:
	grid_position = new_position

func is_alive() -> bool:
	printerr('Missing AI Component on: ', entity_name)
	return false

func interact(itemAction: ItemAction) -> void:
	printerr('Missing Consumable Component on: ', entity_name)
