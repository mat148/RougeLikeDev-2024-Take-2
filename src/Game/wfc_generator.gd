extends Node
class_name WFC_Generator

var tile_config = preload("res://assets/definitions/tiles/tile_config.tres")

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 45

var _rng := RandomNumberGenerator.new()

var dungeon: MapDataWFC
var done: bool = false

func generate_dungeon() -> MapDataWFC:
	dungeon = MapDataWFC.new(map_width, map_height)
	
	for x in map_width:
		for y in map_height:
			var tile = dungeon.tiles[x][y]
			
			if y > 0:
				tile.add_neighbor('NORTH', dungeon.tiles[x][y - 1])
			if x < map_width - 1:
				tile.add_neighbor('EAST', dungeon.tiles[x + 1][y])
			if y < map_height - 1:
				tile.add_neighbor('SOUTH', dungeon.tiles[x][y + 1])
			if x > 0:
				tile.add_neighbor('WEST', dungeon.tiles[x - 1][y])
	
	while !done:
		var result = await waveFunctionCollapse()
		if result == 0:
			done = true
	
	return dungeon

func getEntropy(x, y):
	return dungeon.tiles[x][y].entropy

func getType(x, y):
	return dungeon.tiles[x][y].possibilities[0]

func getLowestEntropy():
	var lowestEntropy = tile_config.tileRules.keys().size() - 1
	for y in map_width:
		for x in map_height:
			var tileEntropy = dungeon.tiles[x][y].entropy
			if tileEntropy > 0:
				if tileEntropy < lowestEntropy:
					lowestEntropy = tileEntropy
	return lowestEntropy

func getTilesLowestEntropy():
	var lowestEntropy = tile_config.tileRules.keys().size() - 1
	var tileList = []

	for y in map_height:
		for x in map_width:
			var tileEntropy = dungeon.tiles[x][y].entropy
			if tileEntropy > 0:
				if tileEntropy < lowestEntropy:
					tileList.clear()
					lowestEntropy = tileEntropy
				if tileEntropy == lowestEntropy:
					tileList.append(dungeon.tiles[x][y])
	return tileList

func waveFunctionCollapse() -> int:
	var tilesLowestEntropy = getTilesLowestEntropy()

	if tilesLowestEntropy == []:
		return 0

	var tileToCollapse = tilesLowestEntropy.pick_random()
	tileToCollapse.collapse()

	var stack: Array = []
	stack.append(tileToCollapse)

	while(!stack.is_empty()):
		var tile = stack.pop_back()
		var tilePossibilities = tile.get_possibilities()
		var directions = tile.get_directions()

		for direction in directions:
			var neighbour = tile.get_neighbor(direction)
			if neighbour.entropy != 0:
				var reduced = neighbour.constrain(tilePossibilities, direction)
				if reduced == true:
					stack.append(neighbour)    # When possibilities were reduced need to propagate further

	return 1
