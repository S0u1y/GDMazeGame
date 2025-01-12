extends Node

var scenes = {
	"AnalysisStage": load("res://AnalysisStage.tscn"),
	"Game": load("res://game.tscn"),
	"TwoPlayerGame": load("res://TwoPlayerGame.tscn"),
}

func _ready():
	var directory = Directory.new()
	if directory.open("res://MainMenuScreens/") == OK:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			if file_name == "." or file_name == ".." or file_name.begins_with("__"):
				file_name = directory.get_next()
				continue
			if file_name.ends_with(".tscn"):
				scenes[file_name.split(".tscn")[0]] = load("res://MainMenuScreens/" + file_name)
			
			file_name = directory.get_next()
	
#	print(scenes)

func get_scene(scene_name) -> PackedScene:
	if scenes.has(scene_name):
		return scenes[scene_name]
	return null
