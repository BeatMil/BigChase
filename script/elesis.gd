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


# dash mechanic helper
export var dash_trigger_right = false
export var dash_trigger_left = false
export var is_dashing_right = false
export var is_dashing_left = false

# run mechanic
var is_running = false
var is_running_left = false

# hitbox
onready var hitbox01 = load("res://prefabs/hitboxes/hitbox01.tscn")

# stun helper
export var stun01 = false
var stun_right = false
var stun_left = false
var stun_power_right = Vector2(2000,-900)
var stun_power_left = Vector2(-2000,-900)

func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	# normal attack
	if Input.is_action_just_pressed("p1_attack"):
		print("attack01 played")
		$AnimationPlayer.play("attack01")


	if Input.is_action_pressed("p1_up"):
		if is_on_floor():
			motion.y -= JUMP_POWER

	# stop moving when both right and left are pressed
	if Input.is_action_pressed("p1_right") and Input.is_action_pressed("p1_left"):
		motion.x = 0
	elif Input.is_action_just_released("p1_right"):
		is_running = false
	elif Input.is_action_just_released("p1_left"):
		is_running = false
	elif Input.is_action_pressed("p1_right"):
		if is_running == true:
			motion.x = RUN_SPEED
		else:
			motion.x = WALK_SPEED
		$Sprite.set_flip_h(false)
	elif Input.is_action_pressed("p1_left"):
		if is_running == true:
			motion.x = -RUN_SPEED
		else:
			motion.x = -WALK_SPEED
		$Sprite.set_flip_h(true)
	elif Input.is_action_pressed("p1_right") == false:
		motion.x = lerp(motion.x, 0, FRICTION)
	else:
		motion.x = 0

	# check dash right
	if Input.is_action_just_pressed("p1_right"):
		if dash_trigger_right == false:
			$dash_trigger_right_timer.start()
			dash_trigger_right = true
			dash_trigger_left = false
		elif dash_trigger_right == true:
			$dash_trigger_right_timer.stop()
			$dash_length_timer.start()
			dash_trigger_right = false
			is_dashing_right = true

	# check dash left
	if Input.is_action_just_pressed("p1_left"):
		if dash_trigger_left == false:
			$dash_trigger_left_timer.start()
			dash_trigger_left = true
			dash_trigger_right = false
		elif dash_trigger_left == true:
			$dash_trigger_right_timer.stop()
			$dash_length_timer.start()
			dash_trigger_right = false
			is_dashing_left = true

	motion.y += GRAVITY

	if stun01 == true:
		if stun_right == true:
			motion = stun_power_right
		elif stun_left == true:
			motion = stun_power_left
	elif is_dashing_right == true:
		motion.x = DASH
	elif is_dashing_left == true:
		motion.x = -DASH

	motion = move_and_slide(motion, UP)


func _on_dash_trigger_left_timer_timeout():
	dash_trigger_left = false


func _on_dash_trigger_right_timer_timeout():
	dash_trigger_right = false


func _on_dash_length_timer_timeout():
	is_dashing_right = false
	is_dashing_left = false
	is_running = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack01":
		$AnimationPlayer.play("idle")
	
	if anim_name == "idle":
		$AnimationPlayer.stop()



func attack01():
	var offset
	if $Sprite.flip_h == true:
		offset = Vector2(-150,0)
	elif $Sprite.flip_h == false:
		offset = Vector2(150,0)
	var hitbox01_real = hitbox01.instance()
	hitbox01_real.position += offset
	add_child(hitbox01_real) # spawn hitbox


func _on_Area2D_area_entered(area):
	if area.is_in_group("attack"):
		# $hp_bar.decrease_hp(1)
		$stun01_timer.start()
		stun01 = true
		print("stun01 true")
		if $LRayCast2D.is_colliding():
			stun_right = true
		if $RRayCast2D.is_colliding():
			stun_left = true


func _on_stun01_timer_timeout():
	stun01 = false
	print("stun01 false")
