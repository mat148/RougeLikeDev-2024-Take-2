extends BaseObject
class_name Path

func _init(new_position: Vector3i) -> void:
	name = 'Path'
	position = new_position
	polygon = Polygon2D.new()
