extends Node2D
class_name MovementComponent

@export var parent: Node2D

func move(move_offset: Vector3i) -> void:
	parent.grid_position += move_offset

