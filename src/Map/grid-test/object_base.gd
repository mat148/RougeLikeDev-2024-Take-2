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

func intersects(object2: BaseObject) -> bool:
	var polygon2: Polygon2D = object2.polygon
	var intersections: Array[PackedVector2Array] = Geometry2D.intersect_polygons(polygon.polygon, polygon2.polygon)
	
	if intersections.is_empty(): return false
	else: return true

func _is_point_in_polygon(point: Vector2i) -> bool:
	return Geometry2D.is_point_in_polygon(point, polygon.polygon)

func merge_objects(object2: BaseObject) -> Array[PackedVector2Array]:
	var polygon2: Polygon2D = object2.polygon
	var new_object = Geometry2D.merge_polygons(polygon.polygon, polygon2.polygon)
	
	#print(new_object)
	#print(PackedVector2Array(new_object))
	
	return new_object
