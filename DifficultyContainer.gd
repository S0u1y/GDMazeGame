extends VBoxContainer

export var difficulty: Resource
var diff: Difficulty

var diff_size : Vector2

func _ready():
	diff = difficulty
	update_text()

func update_text():
	$Button.text = diff.name
	if GameController.game_type == "Multi":
		diff_size = Vector2(diff.multiplayer_size.x, diff.multiplayer_size.y)
	else:
		diff_size = Vector2(diff.size.x, diff.size.y)
	
	$Features.text = "%dx%d" % [diff_size.x, diff_size.y]

func _on_Button_pressed():
	GameController.n_cols = int (diff_size.x)
	GameController.n_rows = int (diff_size.y)
	GameController.game_difficulty = diff.name
	
	GameController.initialize_new_game()
	GameController.create_maze()
	if GameController.game_type == "Single":
		get_tree().change_scene_to(SceneSwapper.get_scene("Game"))
	else:
		get_tree().change_scene_to(SceneSwapper.get_scene("TwoPlayerGame"))
	
