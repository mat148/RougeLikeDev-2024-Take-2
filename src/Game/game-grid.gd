class_name GameGrid
extends Node2D

#var thread: Thread
const tile_size = 16

@onready var player: EntityNew
@onready var input_handler: InputHandler = $InputHandler
@onready var map: MapGrid = $Map
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	#TODO: Threading
	#thread = Thread.new()
	#thread.start(map.generate)
	player = TileConfig.entity_definition[TileConfig.entity_names.player].instantiate()
	player.place_entity(Vector3i.ZERO)
	
	remove_child(camera)
	player.add_child(camera)
	map.generate(player)
	map.update_fov(player.grid_position)


func _physics_process(_delta: float) -> void:
	var action: Action = input_handler.get_action(player)
	if action:
		var previous_player_position: Vector3i = player.grid_position
		action.perform()
		_handle_enemy_turns()
		if player.grid_position != previous_player_position:
			map.update_fov(player.grid_position)

func _handle_enemy_turns() -> void:
	for entity in get_tree().get_nodes_in_group("actors"):
		if entity == player:
			continue
		print("The %s wonders when it will get to take a real turn." % entity.get_entity_name())

func get_map_data() -> MapDataGrid:
	return map.map_data
