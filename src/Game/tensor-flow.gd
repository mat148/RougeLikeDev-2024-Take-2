extends Node3D

class_name VectorField

@export var grid_width: int = 32
@export var grid_height: int = 32
@export var tile_size: float = 3

var vector_field: Array = []

func _ready():
	initialize_vector_field()
	generate_city()

func initialize_vector_field():
	vector_field = []
	#var center = Vector3(grid_width / 2, 0, grid_height / 2)
	var center = Vector3(32/3, 0, 32/2) * tile_size
	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			var major = (Vector3(x, 0, y) - center).normalized()
			var minor = (Vector3(x, 0, y) + center).normalized()
			var field = [major, minor]
			row.append(field)  # Initialize with zero vectors
			vector_field.append(row)
	
	print_vector_field()

func print_vector_field():
	for row in vector_field:
		var row_str = ""
		for vec in row:
			row_str += str(vec) + " "
		print(row_str)

func generate_city():
	for y in range(grid_height):
		for x in range(grid_width):
			var major = vector_field[x][y][0]
			var minor = vector_field[x][y][1]
			#var direction = vector_field[y][x]
			#direction = Vector3(direction.x, 0, direction.y)
			point(Vector3(x, 0, y) * tile_size)
			draw_road(Vector3(x, 0, y), major, minor)

#func place_road_or_building(position: Vector3, direction: Vector3):
	## Simple example: place roads along the direction vectors
	#if direction.length() > 0.1:
		#draw_road(position, direction)
	#else:
		#draw_building(position)

func draw_road(position: Vector3, major: Vector3, minor: Vector3):
	#var pos1 = position * tile_size
	#var new_dir = direction * tile_size
	#var pos2 = pos1 + new_dir
	
	var pos1 = position * tile_size
	var major_direction = major * tile_size
	var major_position = pos1 + major_direction
	var minor_direction = minor * tile_size
	var minor_position = pos1 + minor_direction
	
	# Replace this with your method to place a road at the given position
	print("Road at ", pos1, " in direction ", major_direction, minor_direction)
	line(pos1, major_position)
	line(pos1, minor_position, Color.RED)

func draw_building(position: Vector3):
	# Replace this with your method to place a building at the given position
	print("Building at ", position)

func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	#return await final_cleanup(mesh_instance, persist_ms)
	add_child(mesh_instance)

func point(pos: Vector3, radius = 0.05, color = Color.SEA_GREEN, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos

	sphere_mesh.radius = radius
	sphere_mesh.height = radius*2
	sphere_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	add_child(mesh_instance)

func final_cleanup(mesh_instance: MeshInstance3D, persist_ms: float):
	get_tree().get_root().add_child(mesh_instance)
	if persist_ms == 1:
		await get_tree().physics_frame
		mesh_instance.queue_free()
	elif persist_ms > 0:
		await get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance
