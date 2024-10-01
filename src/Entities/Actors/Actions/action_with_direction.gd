class_name ActionWithDirection
extends Action

var offset: Vector3i

func _init(entity: Entity, dx: int, dy: int, dz: int) -> void:
	super._init(entity)
	offset = Vector3i(dx, dy, dz)

func get_destination() -> Vector3i:
	return entity.grid_position + offset

func get_blocking_entity_at_destination() -> Entity:
	return get_map_data().get_blocking_entity_at_location(get_destination())

func get_target_actor() -> Entity:
	return get_map_data().get_actor_at_location(get_destination())
