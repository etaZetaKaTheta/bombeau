extends Node

var network = NetworkedMultiplayerENet.new()
var port = 18771
var max_players = 12

func _ready():
	start_server()

func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("SERVER STARTED")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	
remote func fetch_bomb_damage(bomb_name, requester_id):
	var player_id = get_tree().get_rpc_sender_id()
	var damage = ServerData.main_data[bomb_name].damage
	rpc_id(player_id, "return_bomb_damage", damage, requester_id)
	print("Sending " + str(damage) + " to player " + str(player_id))
	
func _peer_connected(player_id):
	print("Player " + str(player_id) + " connected")
	
func _peer_disconnected(player_id):
	print("Player " + str(player_id) + " disconnected")
