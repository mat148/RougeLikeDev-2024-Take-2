class_name Game
extends Node2D

const player_definition: EntityDefinition = preload("res://assets/definitions/entities/actors/entity_definition_player.tres")
const tile_size = 16

@onready var player: Entity
@onready var event_handler: EventHandler = $EventHandler
@onready var map: Map = $Map
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	player = Entity.new(Vector2i.ZERO, player_definition)
	remove_child(camera)
	player.add_child(camera)
	entities.add_child(player)
	map.generate(player)
	map.update_fov(player.grid_position)


func _physics_process(_delta: float) -> void:
	var action: Action = event_handler.get_action()
	if action:
		var previous_player_position: Vector2i = player.grid_position
		action.perform(self, player)
		if player.grid_position != previous_player_position:
			map.update_fov(player.grid_position)


func get_map_data() -> MapData:
	return map.map_data
