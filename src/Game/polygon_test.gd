extends Node2D

@export var polygon1: Polygon2D
@export var polygon2: Polygon2D

@export var polygon3: Polygon2D

func _ready() -> void:
	var transformed_polygon_1 = polygon1.transform * polygon1.polygon
	polygon1.transform = Transform2D.IDENTITY
	polygon1.polygon = transformed_polygon_1

	var transformed_polygon_2 = polygon2.transform * polygon2.polygon
	polygon2.transform = Transform2D.IDENTITY
	polygon2.polygon = transformed_polygon_2
	
	var merged_polygon = Geometry2D.merge_polygons(polygon1.polygon, polygon2.polygon)
	
	polygon3.polygon = merged_polygon[0]
	print(merged_polygon)
