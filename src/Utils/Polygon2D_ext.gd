extends Polygon2D
class_name Polygon2D_ext

var ref_name = ""

func get_bounding_box() -> Dictionary:
	var points: PackedVector2Array = polygon
	
	var min_x = points[0].x
	var max_x = points[0].x
	var min_y = points[0].y
	var max_y = points[0].y
	
	for point in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	return {'min_x': min_x, 'max_x': max_x, 'min_y': min_y, 'max_y': max_y}

func _is_point_in_polygon(point: Vector2i) -> bool:
	var points: PackedVector2Array = polygon
	var inside = false
	var j = points.size() - 1
	for i in range(points.size()):
		var xi = points[i].x
		var yi = points[i].y
		var xj = points[j].x
		var yj = points[j].y
		var intersect = ((yi > point.y) != (yj > point.y)) and \
				(point.x < (xj - xi) * (point.y - yi) / (yj - yi) + xi)
		if intersect:
			inside = not inside
		j = i
	return inside

func intersects(polygon2: Plot) -> bool:
	var bounding_box_1: Dictionary = get_bounding_box()
	var bounding_box_2: Dictionary = polygon2.get_bounding_box()
	
	if not bounding_boxes_intersect(bounding_box_1, bounding_box_2):
		return false
	
	var polygon1 = polygon
	if edges_intersect(polygon1, polygon2.polygon):
		return true
	
	for point in polygon1:
		if is_point_in_polygon(point, polygon2.polygon):
			return true
	for point in polygon2.polygon:
		if is_point_in_polygon(point, polygon1):
			return true
	
	return false

func bounding_boxes_intersect(bounding_box_1: Dictionary, bounding_box_2: Dictionary) -> bool:
	var min_x_1 = bounding_box_1.min_x
	var max_x_1 = bounding_box_1.max_x
	var min_y_1 = bounding_box_1.min_y
	var max_y_1 = bounding_box_1.max_y
	
	var min_x_2 = bounding_box_2.min_x
	var max_x_2 = bounding_box_2.max_x
	var min_y_2 = bounding_box_2.min_y
	var max_y_2 = bounding_box_2.max_y
	
	return !(min_x_1 > max_x_2 or min_x_2 > max_x_1 or min_y_1 > max_y_2 or min_y_2 > max_y_1)

func edges_intersect(polygon1: Array[Vector2i], polygon2: Array[Vector2i]) -> bool:
	for i in range(polygon1.size()):
		var a1 = polygon1[i]
		var a2 = polygon1[(i + 1) % polygon1.size()]
		
		for j in range(polygon2.size()):
			var b1 = polygon2[j]
			var b2 = polygon2[(j + 1) % polygon2.size()]
		
			if line_segments_intersect(a1, a2, b1, b2):
				return true
	
	return false

func line_segments_intersect(p1: Vector2, p2: Vector2, q1: Vector2, q2: Vector2) -> bool:
	var r = p2 - p1
	var s = q2 - q1
	var rxs = r.cross(s)
	var q_p = q1 - p1
	var qpxr = q_p.cross(r)
	
	if rxs == 0 and qpxr == 0:
		# Collinear case, check for overlap
		return (q1 - p1).dot(q1 - p2) <= 0 or (q2 - p1).dot(q2 - p2) <= 0
	
	if rxs == 0 and qpxr != 0:
		return false
	
	var t = q_p.cross(s) / rxs
	var u = q_p.cross(r) / rxs
	
	return (t >= 0 and t <= 1 and u >= 0 and u <= 1)

func is_point_in_polygon(point: Vector2i, polygon: Array[Vector2i]) -> bool:
	var inside = false
	var j = polygon.size() - 1

	for i in range(polygon.size()):
		var vi = polygon[i]
		var vj = polygon[j]
		if ((vi.y > point.y) != (vj.y > point.y)) and \
	(point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x):
			inside = not inside
			j = i
	
	return inside
