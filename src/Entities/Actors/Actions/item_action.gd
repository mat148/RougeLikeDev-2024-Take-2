class_name ItemAction
extends Action

var item: Entity
var target_position: Vector3i

func _init(entity: Entity, item: Entity, target_position = null) -> void:
	super._init(entity)
	self.item = item
	if not target_position is Vector3i:
		target_position = entity.grid_position
	self.target_position = target_position

#func get_target_actor() -> Entity:
	#return get_map_data().get_actor_at_location(target_position)

func perform() -> void:
	item.interact(self)
