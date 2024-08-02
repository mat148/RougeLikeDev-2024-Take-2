class_name Game3D
extends Node3D

const player_definition: EntityDefinition = preload("res://assets/definitions/entities/actors/entity_definition_player.tres")
const tile_size = 0.16

@onready var player: Entity3D
@onready var event_handler: EventHandler = $EventHandler
@onready var map: Map3D = $Map
@onready var camera: Camera3D = $Camera2D

@onready var label: Label = %Label

var current_layer: int = 0


func _ready() -> void:
	player = Entity3D.new(Vector3i.ZERO, player_definition)
	remove_child(camera)
	player.add_child(camera)
	%Entities.add_child(player)
	await map.generate(player)
	#map.update_fov(player.grid_position)
	current_layer = player.position.z
	
	camera.position.z = current_layer + 3
	show_layer(0)

func _physics_process(_delta: float) -> void:
	var action: Action = event_handler.get_action()
	if action:
		var previous_player_position: Vector3i = player.grid_position
		action.perform(self, player)
		#if player.grid_position != previous_player_position:
			#map.update_fov(player.grid_position)


func get_map_data() -> MapData3D:
	return map.map_data

func show_layer(move: int) -> void:
	if current_layer + move < map.map_data.depth && current_layer + move >= 0:
		#Hide previous layer
		for x in map.map_data.width:
			for y in map.map_data.height:
				map.map_data.get_tile(Vector3i(x,y,current_layer)).visible = false
		
		#show new layer
		current_layer += move
		for x in map.map_data.width:
			for y in map.map_data.height:
				map.map_data.get_tile(Vector3i(x,y,current_layer)).visible = true
		
		player.show_layer(current_layer)
		camera.position.z = ((current_layer + 12) * tile_size)
		
		label.text = str(current_layer)

func _on_event_handler_up_layer() -> void:
	show_layer(1)

func _on_event_handler_down_layer() -> void:
	show_layer(-1)
