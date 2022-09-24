extends Node

var main_data

func _ready():
	var main_data_file = File.new()
	main_data_file.open("res://data/MainData.json", File.READ)
	var main_data_json = JSON.parse(main_data_file.get_as_text())
	main_data_file.close()
	main_data = main_data_json.result
