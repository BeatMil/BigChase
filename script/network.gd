extends Node

const PORT = 50021
const MAX_PLAYER = 6
onready var BOB = load("res://enities/players/bob_help.tscn")
onready var FOOK = load("res://enities/players/fook_it.tscn")
onready var PLAYER = load("res://enities/players/p1.tscn")
onready var PUSER = load("res://enities/players/PlayerUser.tscn")
onready var color = Color(1, 0.5, 1)
const MENU = "res://scene/menu.tscn"


func _ready():
	var _ok1 = get_tree().connect("network_peer_connected", self, "player_connected")
	var _ok2 = get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	var _ok3 = get_tree().connect("connected_to_server", self, "connected_to_server")
	var _ok4 = get_tree().connect("connection_failed", self, "connection_failed")


func host():
	var network = NetworkedMultiplayerENet.new()
	network.create_server(PORT, MAX_PLAYER)
	get_tree().set_network_peer(network)
	spawn_player(get_tree().get_network_unique_id())


func join(ip: String):
	var network = NetworkedMultiplayerENet.new()
	network.create_client(ip, PORT)
	get_tree().set_network_peer(network)


remote func register_player():
	pass


# sever side
func player_connected(id):
	print("player connected: ", id)
	spawn_player(id)
#	rpc_id(id, "spawn_player", id, color)


# sever side
func player_disconnected(id):
	print("player disconnected: ", id)
	if Player.get_node_or_null(str(id)):
		Player.get_node_or_null(str(id)).queue_free()


# client only
func connected_to_server():
	# spawn player from players_alive[]
	spawn_player(get_tree().get_network_unique_id())
	get_node("/root/menu/wait_ui").visible = false


# client only
func connection_failed():
	print("failed to connect to server :(")
	get_tree().change_scene(MENU)


remotesync func spawn_player(id: int):
	# var player = PLAYER.instance()
	var player = PUSER.instance()
	player.get_node("char/Sprite").modulate = color
	#player.modulate = color
	player.position = get_node("/root/menu/SpawnPosition2D").position
	player.name = str(id)
	player.set_network_master(id)
	Player.add_child(player)
