extends VBoxContainer

export var difficulty: Resource
var diff: Difficulty

func _ready():
	diff = difficulty
	$Button.text = diff.name
	$Features.text = "%dx%d" % [diff.size.x, diff.size.y]

func _on_Button_pressed():
	GameController.n_cols = int (diff.size.x)
	GameController.n_rows = int (diff.size.y)
	GameController.game_difficulty = diff.name
	
	GameController.initialize_new_game()
	GameController.create_maze()
	get_tree().change_scene_to(SceneSwapper.get_scene("Game"))
