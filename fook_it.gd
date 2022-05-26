extends KinematicBody2D

const MOTION_SPEED = 90.0

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

export var stunned = false


var current_anim = ""
var prev_bombing = false
var bomb_index = 0


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
		motion = puppet_motion

	var new_anim = "standing"
	if motion.y < 0:
		new_anim = "walk_up"
	elif motion.y > 0:
		new_anim = "walk_down"
	elif motion.x < 0:
		new_anim = "walk_left"
	elif motion.x > 0:
		new_anim = "walk_right"

	if stunned:
		new_anim = "stunned"

	# FIXME: Use move_and_slide
	move_and_slide(motion * MOTION_SPEED)
	if not is_network_master():
		puppet_pos = position # To avoid jitter


puppet func stun():
	stunned = true


master func exploded(_by_who):
	if stunned:
		return
	rpc("stun") # Stun puppets
	stun() # Stun master - could use sync to do both at once


func set_player_name(new_name):
	get_node("label").set_text(new_name)


func _ready():
	stunned = false
	puppet_pos = position
