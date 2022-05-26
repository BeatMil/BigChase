extends Node

const PORT = 50021
onready var BOB = load("res://enities/players/bob_help.tscn")
onready var FOOK = load("res://enities/players/fook_it.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func host() -> int:
	var network = NetworkedMultiplayerENet.new()
	network.create_server(PORT, 2)
	get_tree().set_network_peer(network)
	var is_server = get_tree().is_network_server()
	var network_id = network.get_unique_id()
	print("is_server: ", is_server)
	print("network_id: ", network.get_unique_id())
	print(IP.get_local_addresses())
	
	# connect signals
	var peer_connected_signal = network.connect("peer_connected",self,"_peer_connected")
	var peer_disconnected_signal = network.connect("peer_disconnected",self,"_peer_disconnected")
	print("peer_connected_status: ", peer_connected_signal)
	print("peer_disconnected_status: ", peer_disconnected_signal)
	return network_id


func join(ip_address: String) -> int:
	var network = NetworkedMultiplayerENet.new()
	var connection_status = network.create_client(ip_address, PORT)
	get_tree().set_network_peer(network)
	var network_id = network.get_unique_id()
	var connection_failed_signal = network.connect("connection_failed",self,"_on_connection_failed")
	get_tree().multiplayer.connect("network_peer_packet",self,"_on_packet_received")
	print(IP.get_local_addresses())
	print("network_id: ", network.get_unique_id())
	print("connection_failed_signal: ", connection_failed_signal)
	print("connection_status : ", connection_status)
	return network_id


func _on_connection_failed():
	print("connection failed...")


func _peer_connected(id):
#	$user_count_label.text = "Total Users:" + str(get_tree().get_network_connected_peers().size())
	print("peer connected! ", id)
	instance_player(id, FOOK)


func _peer_disconnected(id):
#	$user_count_label.text = "Total Users:" + str(get_tree().get_network_connected_peers().size())
	print("peer disconnected!", id)


func instance_player(network_id: int, entity: Object) -> void:
	var player = entity.instance()
	player.global_position = Vector2(900, 300)
	player.set_network_master(network_id)
	Player.add_child(player)
