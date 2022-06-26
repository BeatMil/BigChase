extends Node2D

onready var PUSER = load("res://enities/players/PlayerUser.tscn")
const PORT = 50021
const MAX_PLAYER = 6

func _ready():
	var network = NetworkedMultiplayerENet.new()
	network.create_server(PORT, MAX_PLAYER)
	get_tree().set_network_peer(network)
	spawn_player(get_tree().get_network_unique_id())


remotesync func spawn_player(id: int):
	var player = PUSER.instance()
	player.name = str(id)
	player.set_network_master(id)
	Player.add_child(player)
