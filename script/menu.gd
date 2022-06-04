extends Node2D

var is_change_jump = false
var is_change_down = false
var is_change_left = false
var is_change_right = false
var is_change_attack = false

const PORT = 50021


# P1
onready var PLAYER = load("res://enities/players/p1.tscn")
onready var BOB = load("res://enities/players/bob_help.tscn")
onready var FOOK = load("res://enities/players/fook_it.tscn")
const MENU = "res://scene/menu.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	var ev = InputEventKey.new()
	ev.scancode = KEY_A
	var ev2 = InputEventKey.new()
	ev2.scancode = KEY_B
	InputMap.action_add_event("p1_attack", ev)
	InputMap.action_add_event("p1_attack", ev2)
#	$ui/Host_Button.grab_focus()


func _physics_process(delta):
	$wait_ui/Label.text = str($wait_ui/Timer.time_left)


func _input(event):
	if is_change_jump and event is InputEventKey and event.pressed:
		InputMap.action_erase_events("p1_up")
		InputMap.action_add_event("p1_up", event)
		is_change_jump = false
		is_change_down = true
		$ui/AnimationPlayer.play("changeDown")
	elif is_change_down and event is InputEventKey and event.pressed:
		InputMap.action_erase_events("p1_down")
		InputMap.action_add_event("p1_down", event)
		is_change_down = false
		is_change_left = true
		$ui/AnimationPlayer.play("changeLeft")
	elif is_change_left and event is InputEventKey and event.pressed:
		InputMap.action_erase_events("p1_left")
		InputMap.action_add_event("p1_left", event)
		is_change_left = false
		is_change_right = true
		$ui/AnimationPlayer.play("changeRight")
	elif is_change_right and event is InputEventKey and event.pressed:
		InputMap.action_erase_events("p1_right")
		InputMap.action_add_event("p1_right", event)
		is_change_right = false
		is_change_attack = true
		$ui/AnimationPlayer.play("changeAttack")
	elif is_change_attack and event is InputEventKey and event.pressed:
		InputMap.action_erase_events("p1_attack")
		InputMap.action_add_event("p1_attack", event)
		is_change_attack = false
		$ui/AnimationPlayer.play("RESET")
	
	if Input.is_action_just_pressed("p1_up"):
		$ui/up_label.modulate = Color(0.4, 1, 0.4)
	elif Input.is_action_just_released("p1_up"):
		$ui/up_label.modulate = Color(1, 1, 1)
	if Input.is_action_just_pressed("p1_down"):
		$ui/down_label.modulate = Color(0.4, 1, 0.4)
	elif Input.is_action_just_released("p1_down"):
		$ui/down_label.modulate = Color(1, 1, 1)
	if Input.is_action_just_pressed("p1_left"):
		$ui/left_label.modulate = Color(0.4, 1, 0.4)
	elif Input.is_action_just_released("p1_left"):
		$ui/left_label.modulate = Color(1, 1, 1)
	if Input.is_action_just_pressed("p1_right"):
		$ui/right_label.modulate = Color(0.4, 1, 0.4)
	elif Input.is_action_just_released("p1_right"):
		$ui/right_label.modulate = Color(1, 1, 1)
	if Input.is_action_just_pressed("p1_attack"):
		$ui/attack_label.modulate = Color(0.4, 1, 0.4)
	elif Input.is_action_just_released("p1_attack"):
		$ui/attack_label.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("ui_cancel"):
		for n in Player.get_children():
			Player.remove_child(n)
			n.queue_free()
		get_tree().change_scene(MENU)


func _on_Button_pressed():
	$ui/Keybind_Button.grab_focus()
	$ui/AnimationPlayer.play("changeJump")
	is_change_jump = true


func _on_Host_Button_pressed():
	$ui.visible = false
	Network.color = $ui/choose_color/Elesis.modulate
	Network.host()


func _on_Join_button_pressed():
	$ui.visible = false
	$wait_ui.visible = true
	$wait_ui/Timer.start()
	Network.color = $ui/choose_color/Elesis.modulate
	Network.join($ui/Ip_TextEdit.text)


func _on_RedButton_pressed():
	$ui/choose_color/Elesis.modulate = $ui/choose_color/RedButton.modulate


func _on_DefultButton_pressed():
	$ui/choose_color/Elesis.modulate = $ui/choose_color/DefultButton.modulate


func _on_BlueButton_pressed():
	$ui/choose_color/Elesis.modulate = $ui/choose_color/BlueButton.modulate


func _on_YellowButton_pressed():
	$ui/choose_color/Elesis.modulate = $ui/choose_color/YellowButton.modulate


func _on_GreenButton_pressed():
	$ui/choose_color/Elesis.modulate = $ui/choose_color/GreenButton.modulate

