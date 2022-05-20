extends Node2D

var is_change_jump = false


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
		print("p1_attack desu")
	if event.is_action_pressed("p1_up"):
		print("p1_up desu")
	if is_change_jump and event is InputEventKey:
		print(event.as_text())
		InputMap.action_add_event("p1_up", event)
		is_change_jump = false
		print("event jump changed")


func _on_Button_pressed():
	is_change_jump = true
	print("button pressed")

