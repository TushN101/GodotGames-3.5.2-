extends KinematicBody2D
onready var animp = $AnimationPlayer
const walk_speed = 50
const run_speed = 120
const jump_force = -150
const gravity = 250
var velocity = Vector2()
var is_running = false
var swordout = false
var attack_sword = false

func sword_attack():
	if Input.is_action_pressed("sword_attack"):
		attack_sword = true
	else: 
		attack_sword = false
	return attack_sword
	
func sword_out():
	if Input.is_action_pressed("sword"):
		swordout = true
	else:
		swordout = false
	return swordout

func is_sprinting():
	if Input.is_action_pressed("shift"):
		is_running = true
	else:
		is_running = false
	return is_running

func get_input():
	
	var input_dir = 0
	if Input.is_action_pressed("left"):
		input_dir = -1
	if Input.is_action_pressed("right"):
		input_dir = 1
	return input_dir
	
func _physics_process(delta):
	var SWORDATTACK = sword_attack()
	var SWORD = sword_out()
	var RUN = is_sprinting()
	var direction = get_input()
	var current_speed = walk_speed
	if direction == 0:
		if SWORD:
			if SWORDATTACK:
				animp.play("sword_attack")
			else:
				animp.play("sword_idle")
		else:
			animp.play("Idle")
	else:
		if RUN:
			if SWORD:
				if SWORDATTACK:
					animp.play("sword_attack")
				else:
					animp.play("sword_run")
			else:
				animp.play("Run")
		else:
			animp.play("walk")
		get_node("AnimatedSprite").flip_h = direction < 0
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
	if not is_on_floor():
		animp.play("jump")
		velocity.y += gravity * delta
	
	if RUN:
		current_speed = run_speed
	else:
		 current_speed = walk_speed
	velocity.x = direction * current_speed
	velocity = move_and_slide(velocity, Vector2.UP, true)
