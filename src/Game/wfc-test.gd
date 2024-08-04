extends Node2D

@onready var map: MapWFC = $Map

func _ready() -> void:
	map.generate()
