extends Node2D

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if is_network_master():
		# stop moving when both right and left are pressed
		if Input.is_action_pressed("p1_right") and Input.is_action_pressed("p1_left"):
			pass
		elif Input.is_action_pressed("p1_right"):
			move_local_x(1000 * delta)
		elif Input.is_action_pressed("p1_left"):
			move_local_x(-1000 * delta)

		rset("puppet_pos", position)
	else:
		position = puppet_pos

	if not is_network_master():
		 puppet_pos = position # To avoid jitter
