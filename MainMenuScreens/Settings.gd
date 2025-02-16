extends Control

onready var algorithm_select = $"%AlgorithmSelect"

func _ready():
	for algorithm in GameController.get_maze_algorithms():
		algorithm_select.add_item(algorithm)

func _on_AlgorithmSelect_item_selected(index):
	var item_text = algorithm_select.get_item_text(index)
	GameController.chosen_algorithm = item_text

func _on_Back_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))

