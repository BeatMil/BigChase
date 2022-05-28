extends KinematicBody2D

# config
const WALK_SPEED = 600
const DASH_SPEED = 2500
const DOWNWARD_DASH = 2000
const FRICTION = 0.2
const GRAVITY = 100
const JUMP_POWER = 2000

# helper
var ready_to_dash = false
var motion = Vector2()
var is_dashing = false


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP)


func walk_right():
	if not is_dashing:
		motion.x = WALK_SPEED
		$Sprite.flip_h = false


func walk_left():
	if not is_dashing:
		motion.x = -WALK_SPEED
		$Sprite.flip_h = true


func downward():
	motion.y = DOWNWARD_DASH


func check_dash(direction: bool):
	# right = true
	# left  = false
	if ready_to_dash:
		ready_to_dash = false
		$CheckDashTimer.stop()
		_dash(direction)
	else:
		ready_to_dash = true
		$CheckDashTimer.start()


func _dash(direction: bool):
	if direction:
		motion.x = DASH_SPEED
		is_dashing = true
	else:
		motion.x = -DASH_SPEED
		is_dashing = true
	$DashTimer.start()


func reset_dash():
	$CheckDashTimer.stop()
	ready_to_dash = false


func stay_still():
	motion.x = 0


func jump():
	if is_on_floor():
		motion.y = -JUMP_POWER


func lerp_motion_x():
	"""
	smooth from run to stay still
	"""
	motion.x = lerp(motion.x, 0, FRICTION)


func _on_DashTimer_timeout():
	is_dashing = false


func _on_CheckDashTimer_timeout():
	ready_to_dash = false
