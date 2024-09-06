extends BaseObject
class_name Road

var direction: Vector2i

func _init(polygonArray: PackedVector2Array, new_direction: Vector2i, new_position: Vector3i) -> void:
	name = "Road"
	position = new_position
	polygon = Polygon2D.new()
	polygon.polygon = polygonArray
	direction = new_direction
