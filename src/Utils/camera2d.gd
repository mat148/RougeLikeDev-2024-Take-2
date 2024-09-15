extends Camera2D

@export var pan_speed: float = 3200
@export var zoom_speed: float = 0.1

#func _ready():
	## Enable camera to follow the player or any target
	#current = true

func _process(delta):
	handle_panning(delta)
	handle_zooming()

func handle_panning(delta):
	var pan_direction = Vector2()
	if Input.is_action_pressed("ui_pan_up"):
		pan_direction.y -= 1
	if Input.is_action_pressed("ui_pan_down"):
		pan_direction.y += 1
	if Input.is_action_pressed("ui_pan_left"):
		pan_direction.x -= 1
	if Input.is_action_pressed("ui_pan_right"):
		pan_direction.x += 1

	position += pan_direction.normalized() * pan_speed * delta

func handle_zooming():
	if Input.is_action_pressed("zoom_in"):
		zoom *= (1 - zoom_speed)
	elif Input.is_action_pressed("zoom_out"):
		zoom *= (1 + zoom_speed)
