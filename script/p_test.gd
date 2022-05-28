# p1.gd
extends Node2D
########################################################
# P1 controls
# put character node inside P1 to control the character
########################################################

puppet var puppet_pos = Vector2()


func _physics_process(delta):
	if is_network_master():
		# stop moving when both right and left are pressed
		if Input.is_action_pressed("p1_right") and Input.is_action_pressed("p1_left"):
			$char.lerp_motion_x()
			$char.reset_dash()
		elif Input.is_action_pressed("p1_right"):
			$char.walk_right()
		elif Input.is_action_pressed("p1_left"):
			$char.walk_left()
		else:
			$char.lerp_motion_x()
		
		if Input.is_action_just_pressed("p1_right"):
			$char.check_dash(true)

		if Input.is_action_just_pressed("p1_left"):
			$char.check_dash(false)

		if Input.is_action_pressed("p1_up"):
			$char.jump()
		
		if Input.is_action_just_pressed("p1_down"):
			$char.downward()

		rset("puppet_pos", $char.position)
#		rset("puppet_flip_h", $char/Sprite.flip_h)
#		rset_unreliable("puppet_pos", $char.position)
	else:
		$char.position = puppet_pos
#		$char/Sprite.flip_h = puppet_flip_h
	
#	if not is_network_master():
#		puppet_pos = position # To avoid jitter


func _ready():
	puppet_pos = $char.position
#	puppet_flip_h = $char/Sprite.flip_h
#func puppet_position_set(new_value) -> void:
#	puppet_position = new_value
#
#	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
#	tween.start()


#func _on_Network_tick_rate_timeout():
#	if is_network_master():
#		rset_unreliable("puppet_position", global_position)
