extends KinematicBody2D

const MOTION_SPEED = 90.0

puppet var puppet_pos = Vector2()


func _physics_process(_delta):
	var motion = Vector2()

	if is_network_master():
		if Input.is_action_pressed("p1_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("p1_right"):
			motion += Vector2(1, 0)
		if Input.is_action_pressed("p1_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("p1_down"):
			motion += Vector2(0, 1)

		rset("puppet_pos", position)
	else:
		position = puppet_pos

	# FIXME: Use move_and_slide
	move_and_slide(motion * MOTION_SPEED)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

func set_player_name(new_name):
	get_node("label").set_text(new_name)


func _ready():
	puppet_pos = position
