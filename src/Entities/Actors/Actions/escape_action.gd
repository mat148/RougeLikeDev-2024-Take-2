class_name EscapeAction
extends Action


func perform(game: GameGrid, _entity: Entity) -> void:
	game.get_tree().quit()
