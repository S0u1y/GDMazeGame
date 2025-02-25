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
			
			copy.file_name = file_name
			
			button_container.add_child(copy)
			copy.visible = true
			
			file_name = directory.get_next()

func _on_Back_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))
