extends HBoxContainer

var analysis_folder = "user://saves/analysis/"

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		GameController.load_game(ProjectSettings.globalize_path(analysis_folder+get_node("FileName").text))
		get_tree().change_scene_to(SceneSwapper.get_scene("AnalysisStage"))
