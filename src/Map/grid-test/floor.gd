extends BaseObject
class_name Floor

var stairway_up_options: Array[EntityNew]:
	get:
		return stairway_up_options
	set(value):
		stairway_up_options.append(value)

var stair_up_locations: Array[EntityNew]:
	get:
		return stair_up_locations
	set(value):
		stair_up_locations.append(value)

var stair_down_locations: Array[EntityNew]:
	get:
		return stair_down_locations
	set(value):
		stair_down_locations.append(value)

var parent_building: Building

func _init(building: Building, polygonArray: PackedVector2Array, new_position: Vector3i) -> void:
	name = 'Floor'
	position = new_position
	polygon = Polygon2D.new()
	polygon.polygon = polygonArray
	parent_building = building
