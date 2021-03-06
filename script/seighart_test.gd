# seightart.gd
extends KinematicBody2D

export var motion = Vector2() # final resuilt of movement
var UP = Vector2(0,-1) # for move_and_slide()
var WALK_SPEED = 600
var GRAVITY = 100
var JUMP_POWER = 2000
var FRICTION = 0.2

# stun helper
var is_stunned = false
var stun_right = Vector2(2000,-900)
var stun_left = Vector2(-2000,-900)

func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	# if Input.is_action_pressed("ui_up"):
	# 	if is_on_floor():
	# 		motion.y -= JUMP_POWER

	# if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
	# 	motion.x = 0
	# elif Input.is_action_pressed("ui_right"):
	# 	motion.x = WALK_SPEED
	# 	$"Sprite".set_flip_h(false)
	# elif Input.is_action_pressed("ui_left"):
	# 	motion.x = -WALK_SPEED
	# 	$"Sprite".set_flip_h(true)
	# elif Input.is_action_pressed("ui_right") == false:
	# 	motion.x = lerp(motion.x, 0, FRICTION)
	# else:
	# 	motion.x = 0
	if is_stunned == true:
		if $LRayCast2D.is_colliding():
			motion = stun_right
		if $RRayCast2D.is_colliding():
			motion = stun_left

	
	# motion.x = lerp(motion.x, 0, FRICTION)
	motion.y += GRAVITY
	motion = move_and_slide(motion, UP)


func _on_Area2D_area_entered(area):
	if area.is_in_group("attack"):
		$stun01_timer.start()
		is_stunned = true


func _on_VisibilityNotifier2D_screen_exited():
	motion = Vector2.ZERO
	$".".global_position = Vector2(1000,100)


func lerp_motion_x():
	"""
	smooth from run to stay still
	"""
	motion.x = lerp(motion.x, 0, FRICTION)


func _on_stun01_timer_timeout():
	is_stunned = false
