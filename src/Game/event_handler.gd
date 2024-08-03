class_name EventHandler
extends Node

signal up_layer
signal down_layer
	

func get_action() -> Action:
	var action: Action = null
	
	if Input.is_action_just_pressed("up"):
		up_layer.emit()
		#action = MovementAction3D.new(0, 0, 1)
	if Input.is_action_just_pressed("down"):
		down_layer.emit()
		#action = MovementAction3D.new(0, 0, -1)
	
	if Input.is_action_just_pressed("move_down"):
		action = MovementAction3D.new(0, -1, 0)
	elif Input.is_action_just_pressed("move_up"):
		action = MovementAction3D.new(0, 1, 0)
	elif Input.is_action_just_pressed("move_left"):
		action = MovementAction3D.new(-1, 0, 0)
	elif Input.is_action_just_pressed("move_right"):
		action = MovementAction3D.new(1, 0, 0)
	
	if Input.is_action_just_pressed("ui_cancel"):
		action = EscapeAction.new()
	
	return action
