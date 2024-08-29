extends BaseObject
class_name Plot

var plot_count: int = 1

func _init(polygonArray: PackedVector2Array, new_position: Vector2i) -> void:
	name = 'Plot'
	position = new_position
	polygon = Polygon2D.new()
	polygon.polygon = polygonArray

func update_plot_count(amount: int) -> void:
	plot_count += amount

func return_plot_count() -> int:
	return plot_count
