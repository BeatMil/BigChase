# p1.gd
extends Node2D
########################################################
# P1 controls
# put character node inside P1 to control the character
########################################################

puppet var puppet_pos = Vector2()


func _physics_process(delta):
	if is_network_master():
		if not $char.is_stunned:
			if Input.is_action_pressed("p1_attack"):
				$char.play_attack01()
				
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
				
			if Input.is_action_just_pressed("p1_down"):
				$char.downward_dash()
#		rset("puppet_pos", $char.position)
		rset_unreliable("puppet_pos", $char.position)
	else:
		$char.position = puppet_pos
	
	if not is_network_master():
		puppet_pos = position # To avoid jitter


func _ready():
	puppet_pos = $char.position

#func puppet_position_set(new_value) -> void:
#	puppet_position = new_value
#
#	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
#	tween.start()


#func _on_Network_tick_rate_timeout():
#	if is_network_master():
#		rset_unreliable("puppet_position", global_position)
