extends Control

func _on_Start_Game_button_down():
	GameController.game_type = "Single"
	get_tree().change_scene_to(SceneSwapper.get_scene("StartGameSettings"))

func _on_2_Player_Game_button_down():
	GameController.game_type = "Multi"
	get_tree().change_scene_to(SceneSwapper.get_scene("StartGameSettings"))

func _on_Analysis_button_down():
	get_tree().change_scene_to(SceneSwapper.get_scene("Analysis"))
#
func _on_Settings_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Settings"))

func _on_CosmeticsMenu_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("CosmeticsMenu"))
