extends Control

onready var algorithm_select = $"%AlgorithmSelect"
onready var gen_type_select = $"%WorldGenTypeSelect"

func _ready():
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/Label.hint_tooltip = "Different algorithms for how the mazes are generated. Some might make the maze easier and some harder."
	var i = 0
	for algorithm in GameController.get_maze_algorithms():
		algorithm_select.add_item(algorithm)
		if algorithm == GameController.chosen_algorithm:
			algorithm_select.select(i)
		
		i += 1
	
	$Panel/VBoxContainer/ScrollContainer/VBoxContainer/MarginContainer2/VBoxContainer/Label.hint_tooltip = "Entire World = The entire world is generated all at once. Longer wait when starting a game.\nChunked = World is generated only around key rooms or entities. May lag while loading new rooms."
	gen_type_select.add_item("Entire World")
	gen_type_select.add_item("Chunked")
	for item in gen_type_select.get_item_count():
		var current_text = gen_type_select.get_item_text(item)
		if current_text == GameController.world_gen:
			gen_type_select.select(item)
			break
		
	

func _on_AlgorithmSelect_item_selected(index):
	var item_text = algorithm_select.get_item_text(index)
	GameController.chosen_algorithm = item_text

func _on_WorldGenTypeSelect_item_selected(index):
	var item_text = gen_type_select.get_item_text(index)
	GameController.world_gen = item_text

func _on_Back_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))



