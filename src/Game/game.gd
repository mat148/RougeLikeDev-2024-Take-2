class_name Game
extends Node2D

const player_definition: EntityDefinition = preload("res://assets/definitions/entities/actors/entity_definition_player.tres")
const tile_size = 16

@onready var player: Entity
@onready var event_handler: EventHandler = $EventHandler
@onready var entities: Node2D = $Entities
@onready var map: Map = $Map


func _ready() -> void:
	player = Entity.new(Vector2i.ZERO, player_definition)
	var camera: Camera2D = $Camera2D
	#remove_child(camera)
	#player.add_child(camera)
	entities.add_child(player)
	await map.generate(Vector2i(1,1))
	
	#var map_dimensions = Vector2(map.map_data.width, map.map_data.height)
	#camera.position = (map_dimensions * tile_size) / 2


#func _physics_process(_delta: float) -> void:
	#var action: Action = event_handler.get_action()
	#if action:
		#action.perform(self, player)


func get_map_data() -> MapData:
	return map.map_data
