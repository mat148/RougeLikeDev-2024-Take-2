class_name MapWFC
extends Node2D

@export var fov_radius: int = 8

var map_data: MapDataWFC
@onready var dungeon_generator: WFC_Generator = $Wfc_generator
#@onready var field_of_view: FieldOfView = $FieldOfView

func generate() -> void:
	map_data = await dungeon_generator.generate_dungeon()
	_place_tiles()

func _place_tiles() -> void:
	for x in range(0, map_data.width, 1):
		for y in range(0, map_data.height, 1):
			add_child(map_data.tiles[x][y])

#func update_fov(player_position: Vector2i) -> void:
	#field_of_view.update_fov(map_data, player_position, fov_radius)
