extends KinematicBody2D
const gravity  = 300
const jump_force = -150
const walk_speed = 50
const run_speed = 100
const crouch_speed = 40
var health = 100

export var climbing = false

var is_punching = false
var is_dead = false
var mouse_in = false
var is_crouching = false
var is_running = false
var is_walking = false
var velocity = Vector2()

onready var animp = $AnimationPlayer
onready var collshape = $CollisionShape2D


func walk_check():
	if Input.is_action_pressed("run"):
		is_walking = false
	if Input.is_action_pressed("crouch"):
		is_walking = false
	else:
		is_walking = true
	return is_walking
	
func run_check():
	if Input.is_action_pressed("run"):
		is_running = true
	else:
		is_running = false
	return is_running
	
func crouch_check():
	if Input.is_action_pressed("crouch"):
		is_crouching = true
	else:
		is_crouching = false
	return is_crouching
	
func get_input():
	var input_dir = 0
	if Input.is_action_pressed("left"):
		input_dir = -1
		get_node("AnimatedSprite").flip_h = true
	if Input.is_action_pressed("right"):
		input_dir = 1
		get_node("AnimatedSprite").flip_h = false
	return input_dir
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("punch"):
		is_punching = true
	
	if health == 0:
		is_dead = true
	if is_dead == true:
		animp.play("death" , 1 , false)
		queue_free()
	var current_speed = walk_speed
	var direction = get_input()
	var RUN = run_check()
	var CROUCH = crouch_check()
	var WALK = walk_check()
	if mouse_in == true and is_dead == false:
		if Input.is_action_just_pressed("attack"):
			animp.play("hurt")
			health = health - 10
			print(health)
			
	if climbing  == false and is_dead == false:
		velocity.y += gravity * delta 
	elif climbing == true and is_dead == false:
		velocity.y = 0
		if Input.is_action_pressed("climb"):
			animp.play("climb")
			velocity.y = -walk_speed
		if Input.is_action_pressed("down"):
			animp.play("climb")
			velocity.y = walk_speed
			
	if not is_on_floor() and climbing==false and is_dead == false:
		animp.play("jump")
		
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = jump_force
		if direction == 0  and not Input.is_action_pressed("attack") and is_dead == false:
			
			if CROUCH:
				animp.play("crouch_idle")
				
			else:
				animp.play("idle")
		elif direction != 0 and not Input.is_action_pressed("attack") and is_dead == false:
			
			if CROUCH and is_dead == false:
				animp.play("crouch_walk")
				current_speed = crouch_speed
				
			elif RUN and is_dead == false:
				animp.play("run")
				current_speed = run_speed
				
			elif WALK and is_dead == false:
				animp.play("walk")
				current_speed = walk_speed
				
		velocity.x = current_speed * direction
		
	velocity = move_and_slide(velocity , Vector2.UP , true)



func _on_Area2D_mouse_entered():
	mouse_in = true
func _on_Area2D_mouse_exited():
	mouse_in = false
