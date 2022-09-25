extends Node

var network = NetworkedMultiplayerENet.new()
var port = 18770
var max_servers = 6

func _ready():
	start_server()

func start_server():
	network.create_server(port, max_servers)
	get_tree().set_network_peer(network)
	print("Authentication server started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")


func _peer_connected(gateway_id):
	print("Gateway " + str(gateway_id) + " connected")
	
func _peer_disconnected(gateway_id):
	print("Gateway " + str(gateway_id) + " disconnected")


remote func authenticate_player(username, password, player_id):
	print("Authentication request received from: " + str(player_id))
	var gateway_id = get_tree().get_rpc_sender_id()
	var result
	print("Starting authentication")
	if not PlayerData.player_ids.has(username):
		print("User not recognized")
		result = false
	elif not PlayerData.player_ids[username].password == password:
		print("Incorrect password")
		result = false
	else:
		print("Successful authentication")
		result = true
	print("Authentication result send to gateway server")
	rpc_id(gateway_id, "authentication_results", result, player_id)
