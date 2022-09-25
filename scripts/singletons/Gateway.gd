extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 18769

var username
var password

func _ready():
	pass
	
# warning-ignore:unused_argument
func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func connect_to_server(_username, _password):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	
	username = _username
	password = _password
	
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")

func _on_connection_succeeded():
	print("Connected successfully to login server")
	request_login()
	
func _on_connection_failed():
	print("Connection to login server failed")
	print("***CONNECTION FAILED***")
	get_node("../Map/GUI/LoginScreen").login_button.disabled = false
	
	

func request_login():
	print("Connecting to gateway to request login")
	rpc_id(1, "login_request", username, password)
	username = ""
	password = ""

remote func return_login_request(results):
	print("Results received")
	if results:
		GameServer.connect_to_server()
		get_node("../Main/GUI/LoginUI").queue_free()
	else:
		print("Please provide correct username and password")
		get_node("../Main/GUI/LoginUI").login_button.disabled = false
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")
	network.disconnect("connection_failed", self, "_on_connection_failed")
