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
			var difficulty_label = copy.get_node("Difficulty")
			if difficulty == null:
				difficulty = ""
				difficulty_label.visible = false
			elif difficulty == "Easy":
				difficulty_label.add_color_override("font_color", Color8(0, 128, 0))
			elif difficulty == "Medium":
				difficulty_label.add_color_override("font_color", Color8(128, 64, 32))
			else:
				difficulty_label.add_color_override("font_color", Color8(128, 0, 0))
			difficulty_label.text = difficulty
			
			copy.get_node("FileName").text = file_name
			copy.visible = true
			
			file_name = directory.get_next()

func _on_Back_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))
