class_name GameGrid
extends Node2D

#var thread: Thread
const tile_size = 16

@onready var player: Entity
@onready var input_handler: InputHandler = $InputHandler
@onready var map: MapGrid = $Map
@onready var camera: Camera2D = $Camera2D

#
#func _ready() -> void:
	##TODO: Threading
	##thread = Thread.new()
	##thread.start(map.generate)

func _generate() -> void:
	player = TileConfig.entity_definition[TileConfig.entity_names.player].instantiate()
	player.place_entity(Vector3i.ZERO)
	player.visible = false
	
	remove_child(camera)
	player.add_child(camera)
	
	map.generate(player)
	map.update_fov(player)


func _physics_process(_delta: float) -> void:
	if player:
		var action: Action = input_handler.get_action(player)
		if action:
			var previous_player_position: Vector3i = player.grid_position
			action.perform()
			_handle_enemy_turns()
			if player.grid_position != previous_player_position:
				map.update_fov(player)

func _handle_enemy_turns() -> void:
	for entity in get_map_data().get_actors():
		if entity.is_alive() and entity != player:
			entity.aiComponent.perform()

func get_map_data() -> MapDataGrid:
	return map.map_data


func _on_button_pressed() -> void:
	_generate()


func _on_plus_button_pressed() -> void:
	camera.zoom += Vector2(1,1)

func _on_minus_button_pressed() -> void:
	if camera.zoom != Vector2(0,0):
		camera.zoom -= Vector2(1,1)
