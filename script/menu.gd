extends Node2D

var is_change_jump = false
const PORT = 50021

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


func _on_Host_Button_pressed():
	$ui.visible = false
	var network = NetworkedMultiplayerENet.new()
	network.create_server(PORT, 2)
	get_tree().set_network_peer(network)
	var is_server = get_tree().is_network_server()
	print("is_server: ", is_server)
	print(IP.get_local_addresses())

	# connect signals
	network.connect("peer_connected",self,"_peer_connected")
	network.connect("peer_disconnected",self,"_peer_disconnected")


func _on_Join_button_pressed():
	var network = NetworkedMultiplayerENet.new()
	network.create_client($ui/Ip_TextEdit.text, PORT)
	get_tree().set_network_peer(network)
	network.connect("connection_failed",self,"_on_connection_failed")
	get_tree().multiplayer.connect("network_peer_packet",self,"_on_packet_received")
	print(IP.get_local_addresses())


func _on_connection_failed():
	$ui/Status_Label.text = "Connect failed"


func _peer_connected(id):
#	$user_count_label.text = "Total Users:" + str(get_tree().get_network_connected_peers().size())
	print("peer connected! ", id)

  
func _peer_disconnected(id):
#	$user_count_label.text = "Total Users:" + str(get_tree().get_network_connected_peers().size())
	print("peer disconnected!", id)
	
