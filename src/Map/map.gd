class_name Map
extends Node2D

var map_data: MapData
@onready var dungeon_generator = $DungeonGenerator

func generate(player: Entity, tile_size: int) -> void:
	map_data = await dungeon_generator.generate_dungeon(player, tile_size)
	_place_tiles()

func _place_tiles() -> void:
	for tile in map_data.tiles:
		add_child(tile)
