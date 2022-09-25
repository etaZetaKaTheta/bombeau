extends Control

onready var username_input = get_node("Background/VBoxContainer/UsernameInput")
onready var password_input = get_node("Background/VBoxContainer/PasswordInput")
onready var login_button = get_node("Background/VBoxContainer/LoginButton")



func _on_LoginButton_button_down():
	if username_input.text == "" or password_input.text == "":
		print("Provide both an username and a password")
		#popup
	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = password_input.get_text()
		print("Login attempt")
		Gateway.connect_to_server(username, password)
