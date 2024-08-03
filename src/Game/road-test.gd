extends Node2D

@onready var camera: Camera2D = $Camera2D

@export var world_width: int = 60
@export var world_height: int = 60

@export var tile_size: int = 16
var total_unit_size: int = 448

@export var num_of_roads: int = 30

var roads: Array[Line2D]

#2 tiles for walkable sidewalk
#1 tile for sidewalk accessories
#1 tile for parking
#2 tiles for driving
#1 tile for center line

#14 tiles per road

func _ready() -> void:
	world_width = ((world_width * tile_size / total_unit_size) * total_unit_size)
	world_height = ((world_height * tile_size / total_unit_size) * total_unit_size)
	
	var world_rect: Rect2 = Rect2(Vector2(0,0), Vector2(world_width, world_height) * tile_size)
	
	var world_line = Line2D.new()
	world_line.width = 1
	world_line.default_color = Color.RED
	world_line.add_point(Vector2(0, 0))
	world_line.add_point(Vector2(world_rect.size.x, 0))
	world_line.add_point(Vector2(world_rect.size.x, world_rect.size.y))
	world_line.add_point(Vector2(0, world_rect.size.y))
	world_line.add_point(Vector2(0, 0))
	add_child(world_line)
	
	for x in range(0, world_rect.size.x, tile_size):
		var line = Line2D.new()
		line.width = 1
		line.add_point(Vector2(x, 0))
		line.add_point(Vector2(x, world_rect.size.y))
		add_child(line)
	
	for y in range(0, world_rect.size.y, tile_size):
		var line = Line2D.new()
		line.width = 1
		line.default_color = Color.CHARTREUSE
		line.add_point(Vector2(0, y))
		line.add_point(Vector2(world_rect.size.x, y))
		add_child(line)
	
	#world width = 4800
	#road 14 tiles = 224
	#plots 14 tiles = 224
	#4800 / 448 = must be even
	
	for x in range(7 * tile_size, world_rect.size.x, (tile_size * 14) * 2):
		var line = Line2D.new()
		line.width = tile_size * 14
		line.add_point(Vector2(x, 0))
		line.add_point(Vector2(x, world_rect.size.y))
		add_child(line)
		roads.append(line)
	
	for y in range(7 * tile_size, world_rect.size.y, (tile_size * 14) * 2):
		var line = Line2D.new()
		line.width = tile_size * 14
		line.add_point(Vector2(0, y))
		line.add_point(Vector2(world_rect.size.x, y))
		add_child(line)
		roads.append(line)
	
	#for y in range(0, world_rect.size.y, tile_size * 14):
		#var line = Line2D.new()
		#line.width = tile_size * 14
		#line.add_point(Vector2(0, y))
		#line.add_point(Vector2(world_rect.size.x, y))
		#add_child(line)
	
	#for road in num_of_roads:
		#var line = Line2D.new()
		#var points = get_random_point_on_rect_edge(world_rect)
		#line.add_point(points[0])
		#line.add_point(points[1])
		#add_child(line)
	
	camera.position = world_rect.get_center()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var road1 = roads[randi_range(0, roads.size() - 1)]
		var road2 = roads[randi_range(0, roads.size() - 1)]
		road1.default_color = Color.BLUE
		road2.default_color = Color.BLUE
		
		print(road1, road2)
		print(get_line_intersection(road1, road2))

func get_random_point_on_rect_edge(rect: Rect2) -> Array[Vector2]:
	var points: Array[Vector2] = []
	var previous_edge = null
	
	for point in 2:
		var random_edge
		if !previous_edge:
			random_edge = randi() % 4  # Randomly select one of the four edges
			previous_edge = random_edge
		else:
			match previous_edge:
				0:
					random_edge = 1
				1:
					random_edge = 0
				2:
					random_edge = 3
				3:
					random_edge = 2
		
		var x: float
		var y: float

		match random_edge:
			0:
				# Top edge
				x = rect.position.x + randf() * rect.size.x
				y = rect.position.y
			1:
				# Bottom edge
				x = rect.position.x + randf() * rect.size.x
				y = rect.position.y + rect.size.y
			2:
				# Left edge
				x = rect.position.x
				y = rect.position.y + randf() * rect.size.y
			3:
				# Right edge
				x = rect.position.x + rect.size.x
				y = rect.position.y + randf() * rect.size.y
		
		points.append(Vector2(x,y))
	
	return points

# Returns the intersection point of two lines or null if they don't intersect
func get_line_intersection(line1: Line2D, line2: Line2D) -> Vector2:
	if line1.points.size() < 2 or line2.points.size() < 2:
		return Vector2.INF

	var p1 = line1.get_point_position(0)
	var p2 = line1.get_point_position(1)
	var p3 = line2.get_point_position(0)
	var p4 = line2.get_point_position(1)

	var s1_x = p2.x - p1.x
	var s1_y = p2.y - p1.y
	var s2_x = p4.x - p3.x
	var s2_y = p4.y - p3.y

	var s = (-s1_y * (p1.x - p3.x) + s1_x * (p1.y - p3.y)) / (-s2_x * s1_y + s1_x * s2_y)
	var t = ( s2_x * (p1.y - p3.y) - s2_y * (p1.x - p3.x)) / (-s2_x * s1_y + s1_x * s2_y)

	if s >= 0 and s <= 1 and t >= 0 and t <= 1:
		return Vector2(p1.x + (t * s1_x), p1.y + (t * s1_y))

	return Vector2.INF
