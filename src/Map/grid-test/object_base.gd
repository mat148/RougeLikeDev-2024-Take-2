extends RefCounted
class_name BaseObject

var name: String = ""
var polygon: Polygon2D
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

func intersects(object1: Polygon2D, object2: Polygon2D) -> bool:
	var intersections: Array[PackedVector2Array] = Geometry2D.intersect_polygons(object1.polygon, object2.polygon)
	
	if intersections.is_empty(): return false
	else: return true

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
