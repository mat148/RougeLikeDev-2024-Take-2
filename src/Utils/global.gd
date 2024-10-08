extends Node

var directions: Array[Vector2] = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT
]

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
