extends BaseObject
class_name Building

var local_dungeon: MapDataGrid

enum building_types { APARTMENT, OFFICE }
var building_type: building_types

var plot_count: int = 1
var plot_size: int = 10
var building_height: int = 6
var building_floors: Array[Floor] = []
var symetrical: bool = true

var polygons: Array[Polygon2D] = []

func _init(new_position: Vector3i, dungeon: MapDataGrid) -> void:
	local_dungeon = dungeon
	name = 'Building'
	position = new_position
	polygon = Polygon2D.new()
	generate_building()
	symetrical = randi() % 2 == 0
	#polygon.polygon = polygonArray
	#building_height = randi_range(1, 5)

func generate_building() -> void:
	var building_plot_size: Vector3 = local_dungeon.building_plot_size
	
	var size: Vector2 = Vector2(randi_range(12, 30), randi_range(12, 30))
	var center_position: Vector2 = Vector2((building_plot_size.x/2) - (size.x/2), (building_plot_size.y/2) - (size.y/2)) + Vector2(position.x, position.y)
	var central_polygon: Polygon2D = new_building(center_position, size)
	polygons.append(central_polygon)
	
	polygon.polygon = central_polygon.polygon

	#var previous_position = center_position
	#var previous_size = size
	#
	##polygon.polygon = merge_objects(polygons)
#
	## Step 2: Generate additional polygons
	#for i in range(4):
		#var direction = Global.directions.pick_random()
#
		## Random size for the new polygon
		#var new_size = Vector2(randi_range(12, 30), randi_range(12, 30))
		#var new_position: Vector2
#
		#if direction == Vector2.UP:
			#new_position = Vector2(previous_position.x + randi_range(-15, 15), previous_position.y - new_size.y)
		#if direction == Vector2.LEFT:
			#new_position = Vector2(previous_position.x - new_size.x, previous_position.y + randi_range(-15, 15))
		#if direction == Vector2.DOWN:
			#new_position = Vector2(previous_position.x + randi_range(-15, 15), previous_position.y + previous_size.y)
		#if direction == Vector2.RIGHT:
			#new_position = Vector2(previous_position.x + previous_size.x, previous_position.y  + randi_range(-15, 15))
#
		#if local_dungeon.is_in_bounds(Vector3(new_position.x, new_position.y, 0)):
			## Create new square polygon
			#var new_polygon = new_building(new_position, new_size)
			#var polygon_intersects: bool = false
			#for polygon in polygons:
				#if intersects(polygon, new_polygon):
					#polygon_intersects = true
			#
			#if !polygon_intersects:
				#polygons.append(new_polygon)
#
				## Update previous position and size
				#previous_position = new_position
				#previous_size = new_size
	#
	#polygon.polygon = merge_objects(polygons)

func new_building(position: Vector2, size: Vector2) -> Polygon2D:
	var points: Array[Vector2i] = [
		Vector2i(position.x, position.y),
		Vector2i(position.x + size.x, position.y),
		Vector2i(position.x + size.x, position.y + size.y),
		Vector2i(position.x, position.y + size.y)
	]
	
	var polygon = Polygon2D.new()
	polygon.polygon = points
	return polygon

func update_plot_count(amount: int) -> void:
	plot_count += amount

func return_plot_count() -> int:
	return plot_count

func get_floor(z: int) -> Floor:
	return building_floors[z]
