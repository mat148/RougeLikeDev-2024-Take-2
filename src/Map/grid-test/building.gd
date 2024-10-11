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
var front_of_building: Vector2
var doors: Array[Vector2]

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
	var polygons_to_merge: Array[Polygon2D] = []
	
	var building_plot_size: Vector3 = local_dungeon.building_plot_size
	var building_plot_position: Vector3 = local_dungeon.building_plot_position
	
	var size: Vector2i = Vector2i(randi_range(12, 30), randi_range(12, 30))
	var center_position: Vector2i = Vector2i((building_plot_size.x/2) - (size.x/2), (building_plot_size.y/2) - (size.y/2)) + Vector2i(position.x, position.y)
	position = Vector3i(center_position.x, center_position.y, 0)
	var central_polygon: Polygon2D = new_area(center_position, size)
	polygons_to_merge.append(central_polygon)
	var path_width: int
	front_of_building = Global.directions.pick_random()
	front_of_building = Vector2.RIGHT
	
	var path_size: Vector2
	
	var path_position: Vector2
	if front_of_building == Vector2.UP || front_of_building == Vector2.DOWN:
		var plot_y: int
		var center_y: int
		path_width = 2 if size.x % 2 == 0 else 3

		var calc_path_x: int = center_position.x + floor(size.x/2) - floor(path_width/2)
		
		if front_of_building == Vector2.UP:
			plot_y = building_plot_position.y
			center_y = center_position.y
			path_position = Vector2(calc_path_x, plot_y)
		else:
			plot_y = building_plot_position.y + building_plot_size.y
			center_y = center_position.y + size.y
			path_position = Vector2(calc_path_x, center_y)
		
		path_size = Vector2(path_width, absi(plot_y - center_y))
		
	else:
		var plot_x: int
		var center_x: int
		path_width = 2 if size.y % 2 == 0 else 3
		
		var calc_path_y: int = center_position.y + floor(size.y/2) - floor(path_width/2)
		
		if front_of_building == Vector2.LEFT:
			plot_x = building_plot_position.x
			center_x = center_position.x
			path_position = Vector2(plot_x, calc_path_y)
		else:
			plot_x = building_plot_position.x + building_plot_size.x
			center_x = center_position.x + size.x
			path_position = Vector2(center_x, calc_path_y)
		
		path_size = Vector2(absi(plot_x - center_x), path_width)
	
	var path_vec3: Vector3 = Vector3(path_position.x, path_position.y, 0)
	var path: Path = Path.new(path_vec3)
	path.polygon = new_area(path_position, path_size)
	sub_areas.append(path)
	
	
	if front_of_building == Vector2.UP:
		if path_width == 3:
			var door = Vector2(path_position.x + 1, path_position.y + path_size.y)
			doors.append(door)
		if path_width == 2:
			var door1 = Vector2(path_position.x, path_position.y + path_size.y)
			doors.append(door1)
			var door2 = Vector2(path_position.x + 1, path_position.y + path_size.y)
			doors.append(door2)
			
	if front_of_building == Vector2.DOWN:
		if path_width == 3:
			var door = Vector2(path_position.x + 1, path_position.y)
			doors.append(door)
		if path_width == 2:
			var door1 = Vector2(path_position.x, path_position.y)
			doors.append(door1)
			var door2 = Vector2(path_position.x + 1, path_position.y)
			doors.append(door2)
			
	if front_of_building == Vector2.LEFT:
		if path_width == 3:
			var door = Vector2(path_position.x + path_size.x, path_position.y + 1)
			doors.append(door)
		if path_width == 2:
			var door1 = Vector2(path_position.x + path_size.x, path_position.y)
			doors.append(door1)
			var door2 = Vector2(path_position.x + path_size.x, path_position.y + 1)
			doors.append(door2)
			
	if front_of_building == Vector2.RIGHT:
		if path_width == 3:
			var door = Vector2(path_position.x, path_position.y + 1)
			doors.append(door)
		if path_width == 2:
			var door1 = Vector2(path_position.x, path_position.y)
			doors.append(door1)
			var door2 = Vector2(path_position.x, path_position.y + 1)
			doors.append(door2)
	
	
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

func new_area(position: Vector2, size: Vector2) -> Polygon2D:
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
