extends EntityNew
class_name Player

@export var textureComponent: TextureComponent
@export var healthComponent: HealthComponent
@export var hitBoxComponent: HitBoxComponent
@export var movementCompoent: MovementComponent

func move(offset: Vector3i) -> void:
	movementCompoent.move(offset)
	map_data.current_layer = grid_position.z
	z_index = map_data.current_layer
