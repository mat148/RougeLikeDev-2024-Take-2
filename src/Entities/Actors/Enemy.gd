extends Entity
class_name Enemy

@export var textureComponent: TextureComponent
@export var healthComponent: HealthComponent
@export var hitBoxComponent: HitBoxComponent
@export var movementCompoent: MovementComponent
@export var aiComponent: AIComponent
@export var attackComponent: AttackComponent

func move(offset: Vector3i) -> void:
	movementCompoent.move(offset)

func is_alive() -> bool:
	return aiComponent != null
