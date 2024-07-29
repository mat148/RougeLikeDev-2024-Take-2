class_name Map
extends Node2D

var map_data: MapData
@onready var dungeon_generator = $DungeonGenerator

func generate(pos: Vector2i) -> void:
	map_data = await dungeon_generator.generate_dungeon(pos)
	_place_tiles()

func _place_tiles() -> void:
	for x in range(0, map_data.width, 1):
		for y in range(0, map_data.height, 1):
			add_child(map_data.tiles[x][y])
