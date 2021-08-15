extends KinematicBody2D

export var motion = Vector2() # final resuilt of movement
var UP = Vector2(0,-1) # for move_and_slide()
var WALK_SPEED = 600
var GRAVITY = 100
var JUMP_POWER = 2000
var FRICTION = 0.2

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

	motion.y += GRAVITY
	motion = move_and_slide(motion, UP)
