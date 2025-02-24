extends Control

export var main_menu_screen: PackedScene

onready var file_info = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/FileInfo
onready var button_container = $Panel/VBoxContainer/ScrollContainer/VBoxContainer

var analysis_folder = "user://saves/analysis/"

func _ready():
	var directory = Directory.new()
	if directory.open(analysis_folder) == OK:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			if file_name == "." or file_name == "..":
				file_name = directory.get_next()
				continue
			var copy = file_info.duplicate()
			button_container.add_child(copy)
			var difficulty = GameController.load_difficulty(ProjectSettings.globalize_path(analysis_folder+file_name))
			if difficulty == null:
				difficulty = ""
			copy.get_node("Difficulty").text = difficulty
			copy.get_node("FileButton").text = file_name
			copy.get_node("FileButton").connect("button_down", self, "_on_file_button_down", [file_name])
			copy.visible = true
			
			file_name = directory.get_next()

func _on_file_button_down(text):
	GameController.load_game(ProjectSettings.globalize_path(analysis_folder+text))
	get_tree().change_scene_to(SceneSwapper.get_scene("AnalysisStage"))


func _on_Back_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))
