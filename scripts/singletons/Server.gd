extends Node

var network = NetworkedMultiplayerENet.new()
var ip_addr = "127.0.0.1"
var port = 18769

func _ready():
	connect_to_server()

func connect_to_server():
	network.create_client(ip_addr, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")
	

func _on_connection_succeeded():
	print("Connected successfully")
	
func _on_connection_failed():
	print("Connection failed")
	
func fetch_bomb_damage(bomb_name, requester_id):
	rpc_id(1, "fetch_bomb_damage", bomb_name, requester_id)
remote func return_bomb_damage(s_damage, requester_id):
	instance_from_id(requester_id).set_bomb_damage(s_damage)
