extends PanelContainer

var analysis_folder = "user://saves/analysis/"
var file_name = ""

func _ready():
	$HBoxContainer/FileName.text = file_name
	if file_name == "":
		return
	set_thumbnail_text()

func set_difficulty_text(data:Dictionary):
	var difficulty = null
	if data.has("game_difficulty"):
		difficulty = data["game_difficulty"]
	var difficulty_label = $HBoxContainer/Difficulty
	if difficulty == null:
		difficulty = "Difficulty"
	elif difficulty == "Easy":
		difficulty_label.add_color_override("font_color", Color8(0, 128, 0))
	elif difficulty == "Medium":
		difficulty_label.add_color_override("font_color", Color8(128, 64, 32))
	else:
		difficulty_label.add_color_override("font_color", Color8(128, 0, 0))
	
	difficulty_label.text = difficulty
	

func set_algorithm_text(data:Dictionary):
	if data.has("algorithm"):
		$HBoxContainer/Algorithm.text = data["algorithm"]
		$HBoxContainer/Algorithm.visible = true
	

func set_thumbnail_text():
	var data:Dictionary = GameController.load_analysis_thumbnail(ProjectSettings.globalize_path(analysis_folder+file_name))
#	set_algorithm_text(data)
	set_difficulty_text(data)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_mask == BUTTON_MASK_LEFT:
		GameController.load_game(ProjectSettings.globalize_path(analysis_folder+file_name))
		get_tree().change_scene_to(SceneSwapper.get_scene("AnalysisStage"))
	

func _on_FileInfo_mouse_entered():
	self_modulate.a = 0.5
	

func _on_FileInfo_mouse_exited():
	self_modulate.a = 0
	
