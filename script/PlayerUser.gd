# PlayerUser.gd
extends Node2D
########################################################
# P1 controls
# put character node inside P1 to control the character
########################################################

puppet var puppet_pos = Vector2()
puppet var puppet_flip_h = false
puppet var puppet_color = Color(1, 1, 1)
var can_respawn_bool = false

func _physics_process(delta):
	if is_network_master():
		if get_node_or_null("char"):
			if not $char.is_stunned and not $char.is_ded:
				if Input.is_action_pressed("p1_up"):
					$char.jump()

				# stop moving when both right and left are pressed
				if Input.is_action_pressed("p1_right") and Input.is_action_pressed("p1_left"):
					$char.lerp_motion_x()
					$char.reset_dash_trigger()
				elif Input.is_action_pressed("p1_right"):
					$char.walk_right()
				elif Input.is_action_pressed("p1_left"):
					$char.walk_left()
				else:
					$char.lerp_motion_x()
				
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
				
				if Input.is_action_just_pressed("p1_attack"):
					$char.play_attack01()

			rset_unreliable("puppet_pos", $char.position)
			rset_unreliable("puppet_flip_h", $char/Sprite.flip_h)
			rset_unreliable("puppet_color", $char/Sprite.modulate)

		if can_respawn_bool:
			if Input.is_action_just_pressed("p1_attack"):
				can_respawn_bool = false
				Network.rpc("spawn_player", get_tree().get_network_unique_id())
#				Network.spawn_player(get_tree().get_network_unique_id())
	else:
		if get_node_or_null("char"):
			$char.position = puppet_pos
			$char/Sprite.flip_h = puppet_flip_h
			$char/Sprite.modulate = puppet_color


func can_respawn():
	can_respawn_bool = true


func _ready():
	puppet_pos = $char.position
	puppet_flip_h = $char/Sprite.flip_h
	
	
#	puppet_flip_h = $char/Sprite.flip_h
#func puppet_position_set(new_value) -> void:
#	puppet_position = new_value
#
#	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
#	tween.start()


#func _on_Network_tick_rate_timeout():
#	if is_network_master():
#		rset_unreliable("puppet_position", global_position)
