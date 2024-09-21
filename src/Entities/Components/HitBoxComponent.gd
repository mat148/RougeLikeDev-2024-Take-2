extends Area2D
class_name HitBoxComponent

@export var healthComponent: HealthComponent

func damage(attack: int) -> void:
	if healthComponent:
		healthComponent.damage(attack)
