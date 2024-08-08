class_name TileDefinition
extends Resource

@export var name: String = ''

@export_category("Visuals")
@export var texture: AtlasTexture
enum tile_rotations {NORTH = 90, EAST = 180, SOUTH = 270, WEST = 0}
@export var rotation: tile_rotations = tile_rotations.WEST
@export_color_no_alpha var color_lit: Color = Color('ff7f00')
@export_color_no_alpha var color_dark: Color = Color('7f3f00')

@export_category("Mechanics")
@export var is_walkable: bool = true
@export var is_transparent: bool = true
