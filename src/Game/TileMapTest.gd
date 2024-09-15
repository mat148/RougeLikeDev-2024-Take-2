extends Node2D

@onready var tileMap: TileMap = $TileMap
@onready var layerLabel: Label = %Label

@export var map_width: int = 132
@export var map_height: int = 132
@export var map_depth: int = 132

const directions = [
	Vector3i.UP,
	Vector3i.LEFT,
	Vector3i.RIGHT,
	Vector3i.DOWN
]

var tileMapLayers: int
var currentLayer: int = 0

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("layer_up") && tileMapLayers:
		print('up')
		if currentLayer + 1 <= tileMapLayers:
			tileMap.set_layer_enabled(currentLayer + 1, true)
			currentLayer += 1
			layerLabel.text = str(currentLayer)
	if Input.is_action_just_pressed("layer_down") && tileMapLayers:
		print('down')
		if currentLayer - 1 >= 0:
			tileMap.set_layer_enabled(currentLayer, false)
			currentLayer -= 1
			layerLabel.text = str(currentLayer)

func _setup() -> void:
	var dungeon := MapDataGrid.new(map_width, map_height, map_depth)
	
	for y: int in map_height:
		for x: int in map_width:
			for z: int in map_depth:
				var check_y: int = y % 2
				
				if check_y == 1:
					_carve_tile(dungeon, x, y, z, TileConfig.tile_names.wall_1)
				else:
					_carve_tile(dungeon, x, y, z, TileConfig.tile_names.tree_1)
	
	for i in range(132):
		var x: int = randi_range(0, map_width - 1)
		var y: int = randi_range(0, map_height - 1)
		var z: int = randi_range(0, map_depth - 1)
		
		_carve_tile(dungeon, x, y, z, TileConfig.tile_names.door_1)
		var neighbors: Array[Vector3i] = []
		for direction in directions:
			var new_location = Vector3i(x, y, z) + direction
			if dungeon.is_in_bounds(new_location):
				neighbors.append(new_location)
		
		for neighbor in neighbors:
			_carve_tile(dungeon, neighbor.x, neighbor.y, neighbor.z, TileConfig.tile_names.grass_1)
	
	_place_tiles(dungeon)
	
	tileMapLayers = tileMap.get_layers_count()
	currentLayer = tileMapLayers
	layerLabel.text = str(currentLayer)

func _carve_tile(dungeon, x: int, y: int, z: int, tile_type: int = TileConfig.tile_names.air, tile_rotation: int = 0) -> void:
	var tile_position = Vector3i(x, y, z)
	var tile: TileGrid = dungeon.get_tile(tile_position)
	tile.tile_rotation = tile_rotation
	if dungeon.tile_config.has_tile_type(tile_type):
		tile.set_tile_type(dungeon.tile_config.get_tile_defininition(tile_type))
	else:
		tile.set_tile_type(dungeon.tile_config.get_tile_defininition(TileConfig.tile_names.air))

func _place_tiles(dungeon) -> void:
	for x in range(0, map_width, 1):
		for y in range(0, map_height, 1):
			for z in range(0, map_depth, 1):
				if x == 0 && y == 0:
					tileMap.add_layer(z)
					tileMap.set_layer_name(z, str(z))
					tileMap.set_layer_z_index(z, z)
				var tile = dungeon.get_tile(Vector3i(x, y, z))
				var tile_rotation = tile.tile_rotation
				var tile_definition: TileDefinition = tile._definition
				var tile_texture: AtlasTexture = tile_definition.dark_texture
				var tile_region: Rect2i = tile_texture.region
				var atlas_coords: Vector2i = tile_region.position / 16
				var _tile_visibliity: bool = tile.visible
				
				tileMap.set_cell(z, Vector2i(x, y), 0, atlas_coords, tile_rotation)
				
				#if tile_visibliity:
					#tileMap.set_cell(z, Vector2i(x, y), 0, atlas_coords, tile_rotation)
				#else:
					#tileMap.set_cell(z, Vector2i(x, y), 0, Vector2i(-1, -1), tile_rotation)

func _on_button_pressed() -> void:
	_setup()
