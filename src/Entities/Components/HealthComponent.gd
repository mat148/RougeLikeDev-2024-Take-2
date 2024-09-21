extends Node2D
class_name HealthComponent

@export var MAX_HEALTH: float = 0.0
var health: float = 0

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack: float) -> void:
	health -= attack
	
	if health <= 0:
		get_parent().queue_free()
