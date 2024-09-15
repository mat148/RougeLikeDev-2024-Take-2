class_name ActionWithDirection
extends Action

var offset: Vector3i

func _init(dx: int, dy: int, dz: int) -> void:
	offset = Vector3i(dx, dy, dz)

func perform(game: GameGrid, entity: Entity) -> void:
	pass
