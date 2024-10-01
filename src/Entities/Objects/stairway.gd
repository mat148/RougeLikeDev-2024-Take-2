extends Entity
class_name StairWay

@export var stairComponent: StairComponent

var floor: Floor

var is_interacting: bool = false
var entity: Entity = null

func interact(itemAction: ItemAction) -> void:
	stairComponent.activate(itemAction)
