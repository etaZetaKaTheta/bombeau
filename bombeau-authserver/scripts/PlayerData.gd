extends Node

var player_ids

func _ready():
	var main_data_file = File.new()
	main_data_file.open("res://data/PlayerData.json", File.READ)
	var main_data_json = JSON.parse(main_data_file.get_as_text())
	main_data_file.close()
	player_ids = main_data_json.result
