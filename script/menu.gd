extends Node2D

var is_change_jump = false
const PORT = 50021


# P1
onready var PLAYER = load("res://enities/players/p1.tscn")
onready var BOB = load("res://enities/players/bob_help.tscn")
onready var FOOK = load("res://enities/players/fook_it.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	var ev = InputEventKey.new()
	ev.scancode = KEY_A
	var ev2 = InputEventKey.new()
	ev2.scancode = KEY_B
	InputMap.action_add_event("p1_attack", ev)
	InputMap.action_add_event("p1_attack", ev2)


func _input(event):
	if event.is_action_pressed("p1_attack"):
		pass
	if event.is_action_pressed("p1_up"):
		pass
	if is_change_jump and event is InputEventKey:
		pass
		InputMap.action_add_event("p1_up", event)
		is_change_jump = false
		pass


func _on_Button_pressed():
	is_change_jump = true


func _on_Host_Button_pressed():
	$ui.visible = false
	Gamestate.host_game("beat")
	Gamestate.spawn_player(get_tree().get_network_unique_id())


func _on_Join_button_pressed():
	$ui.visible = false
	Gamestate.join_game($ui/Ip_TextEdit.text, "bob")
