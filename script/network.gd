extends Node

const PORT = 50021
const MAX_PLAYER = 2
onready var BOB = load("res://enities/players/bob_help.tscn")
onready var FOOK = load("res://enities/players/fook_it.tscn")
onready var PLAYER = load("res://enities/players/p1.tscn")
onready var PUSER = load("res://enities/players/PlayerUser.tscn")
onready var color = Color(0.5, 1, 1)


func _ready():
	get_tree().connect("network_peer_connected", self, "player_connected")
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	get_tree().connect("connected_to_server", self, "connected_to_server")
	

func host(color: Color):
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
#	rpc_id(id, "spawn_player", id, color)


# sever side
func player_disconnected(id):
	print("player disconnected: ", id)
	var dis_player = get_node_or_null(str(id))
	if dis_player:
		dis_player.queue_free()


# client only
func connected_to_server():
	# spawn client side player here
#	var id = get_tree().get_network_unique_id()
#	rpc_id(id, "spawn_player", id, color)
	spawn_player(get_tree().get_network_unique_id())


func spawn_player(id: int):
	# var player = PLAYER.instance()
	var player = PUSER.instance()
#	player.modulate = color
	player.position = Vector2(600, 600)
	player.name = str(id)
	player.set_network_master(id)
	Player.add_child(player)
