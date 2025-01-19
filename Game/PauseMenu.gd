extends CanvasLayer

#onready var map = $"../MapGrid"
onready var title = $Panel/VBoxContainer/Label

func _ready():
	pass 

func change_title_text(new_title: String):
	self.title.text = new_title

func show_end_menu():
	change_title_text("Game Over.")
	$Panel/VBoxContainer/VBoxContainer.get_child(0).hide()
	toggle_menu()
	GameController.save_game()
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
#		if map.showing_map:
#			map.toggle_map()
		toggle_menu()

func toggle_menu():
	if GameController.game_state == "Ended":
		self.visible = true
		GameController.paused = true
		return
	self.visible = not self.visible
	GameController.toggle_pause_game()

func _on_Continue_button_down():
	self.visible = false
	GameController.toggle_pause_game()


func _on_MainMenu_button_down():
	if GameController.game_state != "Ended":
		GameController.save_game()
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))
