extends Control

export var main_menu_screen: PackedScene

onready var file_button: Button = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/FileButton
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
			var copy = file_button.duplicate()
			button_container.add_child(copy)
			copy.text = file_name
			copy.connect("button_down", self, "_on_file_button_down", [copy.text])
			copy.visible = true
			
			file_name = directory.get_next()

func _on_file_button_down(text):
	GameController.load_game(ProjectSettings.globalize_path(analysis_folder+text))
	get_tree().change_scene_to(SceneSwapper.get_scene("AnalysisStage"))


func _on_Back_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))
