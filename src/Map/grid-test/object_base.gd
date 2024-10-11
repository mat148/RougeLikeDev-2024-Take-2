extends RefCounted
class_name BaseObject

var name: String = ""
var polygon: Polygon2D
var sub_areas: Array[BaseObject]
var position: Vector3

func get_bounding_box() -> Dictionary:
	var points: PackedVector2Array = polygon.polygon
	
	var min_x = points[0].x #0
	var max_x = points[0].x #0
	var min_y = points[0].y #0
	var max_y = points[0].y #0
	
	for point in points:
		min_x = min(min_x, point.x) #0
		max_x = max(max_x, point.x) #96
		min_y = min(min_y, point.y) #0
		max_y = max(max_y, point.y) #96
	
	return {'min_x': min_x, 'max_x': max_x, 'min_y': min_y, 'max_y': max_y}

func intersects(object1: Polygon2D, object2: Polygon2D) -> Array:
	var intersections: Array[PackedVector2Array] = Geometry2D.intersect_polygons(object1.polygon, object2.polygon)
	
	if intersections.is_empty(): return []
	else: return intersections

func _is_point_in_polygon(point: Vector2i) -> bool:
	return Geometry2D.is_point_in_polygon(point, polygon.polygon)

#func merge_polygons(polygons):
	#if polygons.size() == 0:
		#return null  # No polygons to merge
	#var merged_polygon = polygons[0]
	#for i in range(1, polygons.size()):
		#merged_polygon = Geometry2D.merge_polygons([merged_polygon, polygons[i]])
	#return merged_polygon

func merge_objects(polygons: Array[Polygon2D]) -> PackedVector2Array:
	if polygons.size() == 0:
		return []
	
	var transformed_polygon_1 = polygons[0].transform * polygons[0].polygon
	polygons[0].transform = Transform2D.IDENTITY
	polygons[0].polygon = transformed_polygon_1
	var merged_polygon = polygons[0].polygon
	
	for i in range(1, polygons.size()):
		var transformed_polygon_2 = polygons[i].transform * polygons[i].polygon
		polygons[i].transform = Transform2D.IDENTITY
		polygons[i].polygon = transformed_polygon_2
		
		var new_polygon = Geometry2D.merge_polygons(merged_polygon, polygons[i].polygon)
		merged_polygon = new_polygon[0]
	
	return merged_polygon

func get_edge_points() -> Array[Vector2]:
	var edge_points: Array[Vector2] = []
	var points: PackedVector2Array = polygon.polygon
	var num_points: int = points.size()

	for i in range(num_points):
		var start_point: Vector2 = points[i]
		var end_point: Vector2 = points[(i + 1) % num_points]  # Wrap around to the first point
		var edge_vector: Vector2 = end_point - start_point
		var edge_length: float = edge_vector.length() - 1

		var num_segments: int = max(1, int(edge_length))
		var segment_vector: Vector2 = edge_vector / num_segments

		for j in range(num_segments):
			var point_on_edge: Vector2 = start_point + segment_vector * j
			edge_points.append(point_on_edge)

	return edge_points
