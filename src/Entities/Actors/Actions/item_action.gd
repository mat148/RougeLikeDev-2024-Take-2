class_name ItemAction
extends Action

var item: EntityNew
var target_position: Vector2i

func _init(entity: EntityNew, item: EntityNew, target_position = null) -> void:
	super._init(entity)
	self.item = item
	if not target_position is Vector3i:
		target_position = entity.grid_position
	self.target_position = target_position

func get_target_actor() -> EntityNew:
	return get_map_data().get_actor_at_location(target_position)

func perform() -> void:
	item.consumable_component.activate(self)
