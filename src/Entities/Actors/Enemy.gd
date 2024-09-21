extends EntityNew
class_name Enemy

@export var textureComponent: TextureComponent
@export var healthComponent: HealthComponent
@export var hitBoxComponent: HitBoxComponent
@export var movementCompoent: MovementComponent

func move(offset: Vector3i) -> void:
	movementCompoent.move(offset)
