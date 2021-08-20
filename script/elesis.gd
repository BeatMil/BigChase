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

# run mechanic
var is_running = false
var is_running_left = false


func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			motion.y -= JUMP_POWER

	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		# stop moving when both right and left are pressed
		motion.x = 0
	elif Input.is_action_just_released("ui_right"):
		is_running = false
	elif Input.is_action_just_released("ui_left"):
		is_running = false
	elif Input.is_action_pressed("ui_right"):
		if is_running == true:
			motion.x = RUN_SPEED
		else:
			motion.x = WALK_SPEED
		$"Sprite".set_flip_h(false)
	elif Input.is_action_pressed("ui_left"):
		if is_running == true:
			motion.x = -RUN_SPEED
		else:
			motion.x = -WALK_SPEED
		$"Sprite".set_flip_h(true)
	elif Input.is_action_pressed("ui_right") == false:
		motion.x = lerp(motion.x, 0, FRICTION)
	else:
		motion.x = 0

	if Input.is_action_just_pressed("ui_right"):
		# check dash right
		if dash_trigger_right == false:
			$dash_trigger_right_timer.start()
			dash_trigger_right = true
			dash_trigger_left = false
		elif dash_trigger_right == true:
			$dash_trigger_right_timer.stop()
			$dash_length_timer.start()
			dash_trigger_right = false
			is_dashing_right = true

	if Input.is_action_just_pressed("ui_left"):
		# check dash left
		if dash_trigger_left == false:
			$dash_trigger_left_timer.start()
			dash_trigger_left = true
			dash_trigger_right = false
		elif dash_trigger_left == true:
			$dash_trigger_right_timer.stop()
			$dash_length_timer.start()
			dash_trigger_right = false
			is_dashing_left = true

	motion.y += GRAVITY

	if is_dashing_right == true:
		motion.x = DASH
		motion = move_and_slide(motion, UP)
	elif is_dashing_left == true:
		motion.x = -DASH
		motion = move_and_slide(motion, UP)
	else:
		motion = move_and_slide(motion, UP)


func _on_dash_trigger_left_timer_timeout():
	dash_trigger_left = false


func _on_dash_trigger_right_timer_timeout():
	dash_trigger_right = false


func _on_dash_length_timer_timeout():
	is_dashing_right = false
	is_dashing_left = false
	is_running = true
