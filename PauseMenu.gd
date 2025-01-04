extends CanvasLayer

onready var map = $"../MapGrid"

func _ready():
	pass 


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if map.showing_map:
			map.toggle_map()
		toggle_menu()

func toggle_menu():
	self.visible = not self.visible
	GameController.paused = not GameController.paused

func _on_Continue_button_down():
	self.visible = false
	GameController.paused = false


func _on_MainMenu_button_down():
	GameController.save_game()
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))
