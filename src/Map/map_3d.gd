class_name Map3D
extends Node3D

@export var fov_radius: int = 8

var map_data: MapData3D
@onready var dungeon_generator: DungeonGenerator3D = $DungeonGenerator
#@onready var field_of_view: FieldOfView = $FieldOfView

func generate(player) -> void:
	map_data = await dungeon_generator.generate_dungeon(player)
	_place_tiles()

func _place_tiles() -> void:
	for x in range(0, map_data.width, 1):
		for y in range(0, map_data.height, 1):
			for z in range(0, map_data.depth, 1):
				add_child(map_data.tiles[x][y][z])

#func update_fov(player_position: Vector2i) -> void:
	#field_of_view.update_fov(map_data, player_position, fov_radius)
