# default_char.gd 
extends KinematicBody2D

# config
export var motion = Vector2() # final resuilt of movement
var UP = Vector2(0,-1) # for move_and_slide()
var WALK_SPEED = 600
var RUN_SPEED = 1200
var GRAVITY = 100
var JUMP_POWER = 2000
var FRICTION = 0.2
var DASH = 2500
var DOWNWARD_DASH = 2000


# sfx
onready var HURTSFX = preload("res://media/sounds/hurt.wav")
onready var JUMPSFX = preload("res://media/sounds/jump.wav")
onready var SLASHSFX = preload("res://media/sounds/slash.wav")


# dash mechanic helper
export var dash_trigger_right = false
export var dash_trigger_left = false
export var is_dashing_right = false
export var is_dashing_left = false
var can_downward_dash = false
var is_running = false


# stun 
var stun01_power_left = Vector2(-1500,-1200)
var stun01_power_right = Vector2(1500,-1200)
var is_stunned = false

# hitbox
onready var hitbox01 = load("res://hitboxes/hitbox01.tscn")

# signal
signal stunned01 


func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if is_dashing_right:
		motion.x =  DASH
	elif is_dashing_left:
		motion.x =  -DASH

	motion.y += GRAVITY
	motion = move_and_slide(motion, UP)


func walk_right():
	if is_running == true:
		motion.x = RUN_SPEED
	else:
		motion.x = WALK_SPEED
	$Sprite.flip_h = false


func walk_left():
	if is_running == true:
		motion.x = -RUN_SPEED
	else:
		motion.x = -WALK_SPEED
	$Sprite.flip_h = true


func stay_still():
	motion.x = 0


func lerp_motion_x():
	"""
	smooth from run to stay still
	"""
	motion.x = lerp(motion.x, 0, FRICTION)


func jump():
	if is_on_floor():
		# $AudioStreamPlayer2D.set_stream(JUMPSFX)
		# $AudioStreamPlayer2D.play()
		motion.y -= JUMP_POWER


# check dash right
func dash_right():
	if dash_trigger_right == false:
		$dash_trigger_right_timer.start()
		dash_trigger_right = true
		dash_trigger_left = false
	elif dash_trigger_right == true:
		$dash_trigger_right_timer.stop()
		$dash_length_timer.start()
		$downward_dash_timer.start()
		can_downward_dash = true
		dash_trigger_right = false
		is_dashing_right = true


# check dash left
func dash_left():
	if dash_trigger_left == false:
		$dash_trigger_left_timer.start()
		dash_trigger_left = true
		dash_trigger_right = false
	elif dash_trigger_left == true:
		$dash_trigger_right_timer.stop()
		$dash_length_timer.start()
		$downward_dash_timer.start()
		can_downward_dash = true
		dash_trigger_right = false
		is_dashing_left = true


func downward_dash():
	if can_downward_dash:
		motion.y += DOWNWARD_DASH


func reset_dash_trigger():
	dash_trigger_right = false
	dash_trigger_left = false
	is_dashing_right = false
	is_dashing_left = false
	is_running = false


func set_run(Bool):
	is_running = Bool


func _on_dash_trigger_right_timer_timeout():
	dash_trigger_right = false


func _on_dash_trigger_left_timer_timeout():
	dash_trigger_left = false


func _on_dash_length_timer_timeout():
	is_dashing_right = false
	is_dashing_left = false
	is_running = true


func _on_downward_dash_timer_timeout():
	can_downward_dash = false


func play_attack01():
	# normal attack
	$AnimationPlayer.play("attack01")


func attack01():
	var offset
	if $Sprite.flip_h == true:
		offset = Vector2(-150,0)
	elif $Sprite.flip_h == false:
		offset = Vector2(150,0)
	var hitbox01_real = hitbox01.instance()
	hitbox01_real.position += offset
	if $Sprite.flip_h == true:
		hitbox01_real.get_node("Area2D").add_to_group("left")
	elif $Sprite.flip_h == false:
		hitbox01_real.get_node("Area2D").add_to_group("right")
	add_child(hitbox01_real) # spawn hitbox


func stun01(direction):
	if direction == 'left':
		motion = stun01_power_left
	elif direction == 'right':
		motion = stun01_power_right
	is_stunned = true
	$stun01_timer.start()


func _on_stun01_timer_timeout():
	is_stunned = false


func _on_Area2D_area_entered(area):
	if area.is_in_group('attack01'):
		emit_signal("stunned01")
		$AudioStreamPlayer2D.set_stream(HURTSFX)
		$AudioStreamPlayer2D.play()
		if area.is_in_group('left'):
			stun01('left')
		elif area.is_in_group('right'):
			stun01('right')


func ded():
	$AnimationPlayer.play("ded")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ded":
		get_parent().queue_free()
