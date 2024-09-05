class_name MapGrid
extends Node2D

@onready var tileMap: TileMap = %TileMap

@export var fov_radius: int = 8

var map_data: MapDataGrid
@onready var dungeon_generator: GridGenerator = $DungeonGenerator
#@onready var field_of_view: FieldOfView = $FieldOfView

enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

func generate(player: Entity) -> void:
	map_data = dungeon_generator.generate_dungeon(player)
	_place_tiles()
	
	#return map_data

func _place_tiles() -> void:
	for x in range(0, map_data.width, 1):
		for y in range(0, map_data.height, 1):
			var tile = map_data.get_tile(Vector2i(x, y))
			var tile_rotation = tile.tile_rotation
			var tile_definition: TileDefinition = tile._definition
			var tile_texture: AtlasTexture = tile_definition.texture
			var tile_region: Rect2i = tile_texture.region
			var atlas_coords: Vector2i = tile_region.position / 16
			
			tileMap.set_cell(0, Vector2i(x, y), 0, atlas_coords, tile_rotation)
			#call_deferred("add_child", map_data.tiles[x][y])

#func update_fov(player_position: Vector2i) -> void:
	#field_of_view.update_fov(map_data, player_position, fov_radius)
