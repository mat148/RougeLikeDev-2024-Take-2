extends Camera3D

@export var rotation_speed: float = 0.01
@export var pan_speed: float = 8
@export var zoom_speed: float = 0.3

var drag_active: bool = false
var last_mouse_position: Vector2

#func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		if drag_active:
			rotate_camera(event.relative)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				drag_active = true
				last_mouse_position = event.position
			else:
				drag_active = false
		#elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#zoom_camera(-zoom_speed)
		#elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#zoom_camera(zoom_speed)

func _process(delta):
	if Input.is_action_pressed("zoom_out"):
		zoom_camera(-zoom_speed)
	if Input.is_action_pressed("zoom_in"):
		zoom_camera(zoom_speed)
	if Input.is_action_pressed("ui_pan_up"):
		pan_camera(Vector3(0, pan_speed * delta, 0))
	if Input.is_action_pressed("ui_pan_down"):
		pan_camera(Vector3(0, -pan_speed * delta, 0))
	if Input.is_action_pressed("ui_pan_left"):
		pan_camera(Vector3(-pan_speed * delta, 0, 0))
	if Input.is_action_pressed("ui_pan_right"):
		pan_camera(Vector3(pan_speed * delta, 0, 0))

func rotate_camera(relative_motion: Vector2):
	var h_rotation = Vector3(0, -relative_motion.x * rotation_speed, 0)
	var v_rotation = Vector3(-relative_motion.y * rotation_speed, 0, 0)
	rotate_x(v_rotation.x)
	rotate_y(h_rotation.y)

func pan_camera(offset: Vector3):
	translate(offset)

func zoom_camera(offset: float):
	translate(Vector3(0, 0, offset))
