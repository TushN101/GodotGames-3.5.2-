#The same fps movement 
extends KinematicBody

export var gravity = -500
export var max_speed = 10
var mouse_sens = 0.1
var velocity = Vector3()

onready var gun = $CameraPivot/Camera/Pistol
onready var camera = $CameraPivot/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input(): #Deals with keyboard input
	var  input_dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event): # Deals with mouse looking
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		camera.rotate_x(deg2rad(-event.relative.y * mouse_sens))
		camera.rotation.x = clamp(camera.rotation.x , deg2rad(-89) , deg2rad(89))

func _physics_process(delta):
	velocity.y = gravity * delta
	var desired_velocity  = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity , Vector3.UP , true)
	if Input.is_action_pressed("left_click"):
		gun.shoot()
	
