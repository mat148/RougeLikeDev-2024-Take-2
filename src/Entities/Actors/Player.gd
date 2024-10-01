extends Entity
class_name Player

@export var textureComponent: TextureComponent
@export var healthComponent: HealthComponent
@export var hitBoxComponent: HitBoxComponent
@export var movementCompoent: MovementComponent
@export var attackComponent: AttackComponent

var is_player_alive: bool = true

func move(offset: Vector3i) -> void:
	movementCompoent.move(offset)
	map_data.current_layer = grid_position.z
	z_index = map_data.current_layer + 1

func is_alive() -> bool:
	return is_player_alive != false
