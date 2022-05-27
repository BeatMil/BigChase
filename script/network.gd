extends Node

const PORT = 50021
const MAX_PLAYER = 2
onready var BOB = load("res://enities/players/bob_help.tscn")
onready var FOOK = load("res://enities/players/fook_it.tscn")
onready var PLAYER = load("res://enities/players/p1.tscn")


func _ready():
	get_tree().connect("network_peer_connected", self, "player_connected")
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	get_tree().connect("connected_to_server", self, "connected_to_server")
	

func host():
	var network = NetworkedMultiplayerENet.new()
	network.create_server(PORT, MAX_PLAYER)
	get_tree().set_network_peer(network)
	spawn_player(get_tree().get_network_unique_id())


func join(ip: String):
	var network = NetworkedMultiplayerENet.new()
	network.create_client(ip, PORT)
	get_tree().set_network_peer(network)


# sever side
func player_connected(id):
	print("player connected: ", id)
	spawn_player(id)


# sever side
func player_disconnected(id):
	print("player disconnected: ", id)


# client only
func connected_to_server():
	# spawn client side player here
	spawn_player(get_tree().get_network_unique_id())


func spawn_player(id: int):
	var player = PLAYER.instance()
	player.position = Vector2(600, 600)
	player.set_network_master(id)
	Player.add_child(player)
