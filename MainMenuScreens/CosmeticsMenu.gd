extends Control

var cosmetics = {
}

var selected = null
var selected_idx = 0

func _ready():
	GameController.paused = true
	$Panel/Player1.velocity = Vector2(0, 1.1)
	
	var directory = Directory.new()
	if directory.open("res://assets/Robert/") == OK:
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		while file_name != "":
			if file_name == "." or file_name == ".." or file_name.begins_with("__"):
				file_name = directory.get_next()
				continue
			
			if directory.current_is_dir():
				cosmetics[file_name] = []
				var new_button = Button.new()
				new_button.name = file_name
				new_button.text = file_name
				$Panel/HBoxContainer.add_child(new_button)
				new_button.connect("pressed", self, "_on_cosmetics_picked", [new_button.text])
				
				var cosmetics_dir = Directory.new()
				if cosmetics_dir.open(directory.get_current_dir() + "/" + file_name) == OK:
					cosmetics_dir.list_dir_begin()
					
					var cosmetic_file_name = cosmetics_dir.get_next()
					while cosmetic_file_name != "":
						if cosmetic_file_name.ends_with(".png") or cosmetic_file_name.ends_with(".jpg"):
							cosmetics[file_name].append(load(cosmetics_dir.get_current_dir()+"/"+cosmetic_file_name))
						cosmetic_file_name = cosmetics_dir.get_next()
					
				
			file_name = directory.get_next()
		
	

#disable preview of all other cosmetics and show the picked one
func _on_cosmetics_picked(cosmetic_type:String):
	selected_idx = 0
	selected = cosmetic_type
	
	if not $Panel/HBoxContainer2.visible: $Panel/HBoxContainer2.visible = true
	
	for _cosmetic_type in cosmetics.keys():
		if _cosmetic_type != cosmetic_type:
			var cosmetic_node = $Panel/Player1.get_node(_cosmetic_type)
			if cosmetic_node:
				cosmetic_node.texture = null
		else:
			var cosmetic_node = $Panel/Player1.get_node(cosmetic_type)
			if cosmetic_node:
				cosmetic_node.texture = cosmetics[cosmetic_type][selected_idx]
			
		
	$Panel/HBoxContainer2/Count.text = String(selected_idx+1) + "/" + String(cosmetics[selected].size())
	



func _exit_tree():
	GameController.paused = false

func _on_Back_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))


func _on_Previous_pressed():
	selected_idx += -1
	if selected_idx < 0: selected_idx = 0
	
	var cosmetic_node = $Panel/Player1.get_node(selected)
	if cosmetic_node:
		cosmetic_node.texture = cosmetics[selected][selected_idx]
	
	$Panel/HBoxContainer2/Count.text = String(selected_idx+1) + "/" + String(cosmetics[selected].size())
	

func _on_Next_pressed():
	selected_idx += 1
	if selected_idx > cosmetics[selected].size()-1: selected_idx = cosmetics[selected].size()-1
	
	var cosmetic_node = $Panel/Player1.get_node(selected)
	if cosmetic_node:
		cosmetic_node.texture = cosmetics[selected][selected_idx]
	
	$Panel/HBoxContainer2/Count.text = String(selected_idx+1) + "/" + String(cosmetics[selected].size())
	
