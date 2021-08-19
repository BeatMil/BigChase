extends KinematicBody2D

# config
export var motion = Vector2() # final resuilt of movement
var UP = Vector2(0,-1) # for move_and_slide()
var WALK_SPEED = 600
var GRAVITY = 100
var JUMP_POWER = 2000
var FRICTION = 0.2
var DASH = 2500


# dash mechanic helper
export var dash_trigger = false
export var is_dashing = false


func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if Input.is_action_pressed("ui_up"):
		if is_on_floor():
			motion.y -= JUMP_POWER

	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		motion.x = 0
	elif Input.is_action_pressed("ui_right"):
		motion.x = WALK_SPEED
		$"Sprite".set_flip_h(false)
	elif Input.is_action_pressed("ui_left"):
		motion.x = -WALK_SPEED
		$"Sprite".set_flip_h(true)
	elif Input.is_action_pressed("ui_right") == false:
		motion.x = lerp(motion.x, 0, FRICTION)
	else:
		motion.x = 0

	if Input.is_action_just_pressed("ui_right"):
		if dash_trigger == false:
			$dash_trigger_timer.start()
			dash_trigger = true
		elif dash_trigger == true:
			$dash_trigger_timer.stop()
			$dash_length_timer.start()
			dash_trigger = false
			is_dashing = true

	motion.y += GRAVITY

	if is_dashing == true:
		motion.x = DASH
		print("beat")
		motion = move_and_slide(motion, UP)
	elif is_dashing == false:
		motion = move_and_slide(motion, UP)


func _on_dash_timer_timeout():
	dash_trigger = false


func _on_dash_length_timer_timeout():
	is_dashing = false
