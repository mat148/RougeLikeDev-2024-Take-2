class_name Action
extends RefCounted

var entity: EntityNew

func _init(entity: EntityNew) -> void:
	self.entity = entity

func perform() -> void:
	pass

func get_map_data() -> MapDataGrid:
	return entity.map_data
