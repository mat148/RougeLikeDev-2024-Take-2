extends BaseObject
class_name Building

var plot_count: int = 1
var building_height: int = 6
var building_floors: Array[Floor] = []

func _init(polygonArray: PackedVector2Array, new_position: Vector3i) -> void:
	name = 'Building'
	position = new_position
	polygon = Polygon2D.new()
	polygon.polygon = polygonArray
	#building_height = randi_range(1, 5)

func update_plot_count(amount: int) -> void:
	plot_count += amount

func return_plot_count() -> int:
	return plot_count

func get_floor(z: int) -> Floor:
	return building_floors[z]
