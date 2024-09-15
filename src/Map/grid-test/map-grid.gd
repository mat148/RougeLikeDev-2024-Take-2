class_name MapGrid
extends Node2D

@onready var tileMap: TileMap = %TileMap

@export var fov_radius: int = 8

var map_data: MapDataGrid
@onready var dungeon_generator: GridGenerator = $DungeonGenerator
@onready var field_of_view: FieldOfView = $FieldOfView
@onready var entities: Node2D = %Entities

enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

func generate(player: Entity) -> void:
	map_data = dungeon_generator.generate_dungeon(player)
	_place_tiles()
	_place_entities()

func _place_tiles() -> void:
	for x in range(0, map_data.width, 1):
		for y in range(0, map_data.height, 1):
			for z in range(0, map_data.depth, 1):
				if x == 0 && y == 0:
					tileMap.add_layer(z)
					tileMap.set_layer_name(z, str(z))
					tileMap.set_layer_z_index(z, z)
				var tile = map_data.get_tile(Vector3i(x, y, z))
				var tile_rotation = tile.tile_rotation
				var tile_definition: TileDefinition = tile._definition
				var tile_texture: AtlasTexture = tile_definition.dark_texture
				var tile_region: Rect2i = tile_texture.region
				var atlas_coords: Vector2i = tile_region.position / 16
				var tile_visibliity: bool = tile.visible
				
				if tile_visibliity:
					tileMap.set_cell(z, Vector2i(x, y), 0, atlas_coords, tile_rotation)
				else:
					tileMap.set_cell(z, Vector2i(x, y), 0, Vector2i(-1, -1), tile_rotation)

func _place_entities() -> void:
	for entity in map_data.entities:
		entities.add_child(entity)

func update_fov(player_position: Vector3i) -> void:
	field_of_view.update_fov(map_data, player_position, fov_radius)
	
	for entity in map_data.entities:
		entity.visible = map_data.get_tile(entity.grid_position).is_in_view
