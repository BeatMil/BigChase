# p1.gd
extends Node2D
########################################################
# P1 controls
# put character node inside P1 to control the character
########################################################


func _physics_process(delta):
	if Input.is_action_pressed("p1_up"):
		$char.jump()

	# stop moving when both right and left are pressed
	if Input.is_action_pressed("p1_right") and Input.is_action_pressed("p1_left"):
		$char.reset_dash_trigger()
		$char.stay_still()
	elif Input.is_action_pressed("p1_right"):
		$char.walk_right()
	elif Input.is_action_pressed("p1_left"):
		$char.walk_left()
	elif Input.is_action_pressed("p1_right") == false:
		$char.lerp_motion_x()
	else:
		$char.stay_still()

	# check dash right
	if Input.is_action_just_pressed("p1_right"):
		$char.dash_right()
	elif Input.is_action_just_pressed("p1_left"):
		$char.dash_left()
	elif Input.is_action_just_released("p1_right"):
		$char.set_run(false)
	elif Input.is_action_just_released("p1_left"):
		$char.set_run(false)
