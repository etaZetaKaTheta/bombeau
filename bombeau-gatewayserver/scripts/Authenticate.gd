extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 18770

func _ready():
	connect_to_server()

func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded():
	print("Connected successfully to authentication server")
	
func _on_connection_failed():
	print("Connection failed to authentication server")

func authenticate_player(username, password, player_id):
	print("Sending authentication request")
	rpc_id(1, "authenticate_player", username, password, player_id)

remote func authentication_results(result, player_id):
	print("Results received and replying to player login request")
	Gateway.return_login_request(result, player_id)
