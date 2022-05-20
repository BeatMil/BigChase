# p2.gd
extends Node2D
########################################################
# p2 controls
# put character node inside p2 to control the character
########################################################


func _physics_process(delta):
	if not $char.is_stunned:
		if Input.is_action_pressed("p2_attack"):
			$char.play_attack01()

		if Input.is_action_pressed("p2_up"):
			$char.jump()

		# stop moving when both right and left are pressed
		if Input.is_action_pressed("p2_right") and Input.is_action_pressed("p2_left"):
			$char.reset_dash_trigger()
			$char.stay_still()
		elif Input.is_action_pressed("p2_right"):
			$char.walk_right()
		elif Input.is_action_pressed("p2_left"):
			$char.walk_left()
		elif Input.is_action_pressed("p2_right") == false:
			$char.lerp_motion_x()
		else:
			$char.stay_still()

		# check dash right
		if Input.is_action_just_pressed("p2_right"):
			$char.dash_right()
		elif Input.is_action_just_pressed("p2_left"):
			$char.dash_left()
		elif Input.is_action_just_released("p2_right"):
			$char.set_run(false)
		elif Input.is_action_just_released("p2_left"):
			$char.set_run(false)

		if Input.is_action_just_pressed("p2_down"):
			$char.downward_dash()
