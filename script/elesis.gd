 extends KinematicBody2D

# config
export var motion = Vector2() # final resuilt of movement
var UP = Vector2(0,-1) # for move_and_slide()
var WALK_SPEED = 600
var RUN_SPEED = 1200
var GRAVITY = 100
var JUMP_POWER = 2000
var FRICTION = 0.2
var DASH = 2500


# dash mechanic helper
export var dash_trigger_right = false
export var dash_trigger_left = false
export var is_dashing_right = false
export var is_dashing_left = false
var is_running = false


# hitbox
onready var hitbox01 = load("res://prefabs/hitboxes/hitbox01.tscn")


func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if is_dashing_right:
		motion.x =  DASH
	elif is_dashing_left:
		motion.x =  -DASH

	motion.y += GRAVITY
	motion = move_and_slide(motion, UP)


func walk_right():
	if is_running == true:
		motion.x = RUN_SPEED
	else:
		motion.x = WALK_SPEED
	$Sprite.flip_h = false


func walk_left():
	if is_running == true:
		motion.x = -RUN_SPEED
	else:
		motion.x = -WALK_SPEED
	$Sprite.flip_h = true


func stay_still():
	motion = Vector2.ZERO


func lerp_motion_x():
	motion.x = lerp(motion.x, 0, FRICTION)


func jump():
	if is_on_floor():
		motion.y -= JUMP_POWER


# check dash right
func dash_right():
	if dash_trigger_right == false:
		$dash_trigger_right_timer.start()
		dash_trigger_right = true
		dash_trigger_left = false
	elif dash_trigger_right == true:
		$dash_trigger_right_timer.stop()
		$dash_length_timer.start()
		dash_trigger_right = false
		is_dashing_right = true


# check dash left
func dash_left():
	if dash_trigger_left == false:
		$dash_trigger_left_timer.start()
		dash_trigger_left = true
		dash_trigger_right = false
	elif dash_trigger_left == true:
		$dash_trigger_right_timer.stop()
		$dash_length_timer.start()
		dash_trigger_right = false
		is_dashing_left = true


func set_run(Bool):
	is_running = Bool


func _on_dash_trigger_right_timer_timeout():
	dash_trigger_right = false


func _on_dash_trigger_left_timer_timeout():
	dash_trigger_right = true


func _on_dash_length_timer_timeout():
	is_dashing_right = false
	is_dashing_left = false
	is_running = true
