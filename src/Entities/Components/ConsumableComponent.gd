class_name ConsumableComponent
extends Node2D

@export var parent: Entity

func get_action(consumer: Entity) -> Action:
	return ItemAction.new(consumer, parent)


func activate(action: ItemAction) -> bool:
	return false
