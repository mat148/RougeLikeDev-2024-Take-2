extends BaseObject
class_name Floor

var stair_location: Vector3i

func _init(polygonArray: PackedVector2Array, new_position: Vector3i) -> void:
	name = 'Building'
	position = new_position
	polygon = Polygon2D.new()
	polygon.polygon = polygonArray

func set_stair_location(location: Vector3i) -> void:
	stair_location = location

func get_stair_location() -> Vector3i:
	return stair_location
