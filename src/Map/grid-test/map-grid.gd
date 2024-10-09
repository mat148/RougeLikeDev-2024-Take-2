class_name MapGrid
extends Node2D

var tileMap: TileMap
@export var tileSet: TileSet

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

#func _ready() -> void:
	#SignalBus.interact_event.connect(interact_with_entity)

func generate(player: Entity) -> bool:
	for entity in entities.get_children():
		entity.queue_free()
	
	map_data = dungeon_generator.generate_dungeon(player)
	_place_tiles()
	_place_entities()
	
	map_data.current_layer = player.grid_position.z
	player.z_index = map_data.current_layer
	#tileMap.set_layer_enabled(player.grid_position.z, true)
	
	return true

func _place_tiles() -> void:
	if tileMap:
		tileMap.queue_free()
	tileMap = TileMap.new()
	tileMap.tile_set = tileSet
	add_child(tileMap)
	
	field_of_view.tileMap = tileMap
	
	tileMap.clear()
	for x in range(0, map_data.width, 1):
		for y in range(0, map_data.height, 1):
			for z in range(0, map_data.depth, 1):
				if x == 0 && y == 0:
					tileMap.add_layer(z)
					tileMap.set_layer_enabled(z, false)
					tileMap.set_layer_name(z, str(z))
					tileMap.set_layer_z_index(z, z)
				var tile = map_data.get_tile(Vector3i(x, y, z))
				var tile_rotation = tile.tile_rotation
				var tile_definition: TileDefinition = tile._definition
				var tile_texture: AtlasTexture = tile_definition.dark_texture
				var tile_region: Rect2i = tile_texture.region
				var atlas_coords: Vector2i = tile_region.position / 16
				var tile_visibliity: bool = tile.visible
				
				#not seen tile = solid/transparent
				#seen tile = normal tile
				#visible = lit
				
				if tile_visibliity:
					tileMap.set_cell(z, Vector2i(x, y), 0, atlas_coords, tile_rotation)
				else:
					if tile.parent && tile.parent.name == "Floor":
						tileMap.set_cell(z, Vector2i(x, y), 0, Vector2i(13, 2), tile_rotation)
					else:
						tileMap.set_cell(z, Vector2i(x, y), 0, Vector2i(0, 0), tile_rotation)

func _place_entities() -> void:
	for entity in map_data.entities:
		entities.add_child(entity)

func update_fov(player: Entity) -> void:
	field_of_view.update_fov(map_data, player.grid_position, fov_radius)
	
	var tile_layers: int = tileMap.get_layers_count()
	for layer in tile_layers + 1:
		tileMap.set_layer_enabled(layer, false)
	#player.z_index = player.grid_position.z
	
	for layer in range(tile_layers, -1, -1):
		if layer <= map_data.current_layer:
			tileMap.set_layer_enabled(layer, true)
	
	for entity in map_data.entities:
		var is_visible: bool = map_data.get_tile(entity.grid_position).is_in_view && entity.grid_position.z == map_data.current_layer
		entity.is_in_view = is_visible
		
		#if entity.is_in_group("actors"):
			#entity.is_in_view = is_visible
		#else:
			#entity.is_in_view = is_visible
