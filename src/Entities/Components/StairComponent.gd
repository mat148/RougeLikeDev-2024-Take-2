extends ConsumableComponent
class_name StairComponent

@export var stair_up: bool = false

func activate(action: ItemAction) -> bool:
	var consumer: Entity = action.entity
	var floors: int = parent.floor.parent_building.building_height
	
	if stair_up:
		if consumer.grid_position.z + 1 <= floors:
			MovementAction.new(consumer, 0, 0, 1).perform()
			return true
	else:
		if consumer.grid_position.z - 1 >= 0:
			MovementAction.new(consumer, 0, 0, -1).perform()
			return true
	
	return false
