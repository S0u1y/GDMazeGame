extends Node

var _save: SaveGame = null

func _ready():
	if SaveGame.save_exists():
		_save = SaveGame.load_data() as SaveGame
		_save.player_data.load_new()
		
	else:
		_save = SaveGame.new()
		_save.save_data()
		
	

func _exit_tree():
	save_data()

func save_data():
	_save.save_data()

func get_data() -> PlayerData:
	return _save.get_data()
