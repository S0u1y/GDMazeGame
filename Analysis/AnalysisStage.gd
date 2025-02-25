extends Node2D

var nodes = GameController.get_maze_nodes()

var n_cols = GameController.n_cols
var n_rows = GameController.n_rows
var room_width = GameController.room_width
var room_height = GameController.room_height

onready var walls_node:TileMap = $Walls
onready var collision = $Collisions/Collision

var colors = [
	Color(128, 0, 0),
	Color(0, 0, 128)
]
var selected_player_idx = 0

func _ready():
	var minutes = GameController.get_time()/60
	$CanvasLayer/InfoContainer/Time.text = "Time %d:%d" % [minutes, (minutes - floor(minutes))*100]
	
	var movements: Array = GameController.get_analyzed_movement()
	for i in movements.size():
		if movements[i].empty():
			break
		
		var new_path = $Paths/PlayerPath.duplicate()
		new_path.movements = movements[i]
		new_path.color = colors[i]
		new_path.emit_signal("draw")
		$Paths.add_child(new_path)
		
		var new_player_idx_button = Button.new()
		new_player_idx_button.text = "Player#%d" % i
		$CanvasLayer/VBoxContainer/ScrollContainer/HBoxContainer.add_child(new_player_idx_button)
		new_player_idx_button.connect("pressed", self, "select_player", [i])
		
	
	generate_collisions()
	generate_heatmap()
	generate_maze()
	

func select_player(idx):
	selected_player_idx = idx
	$CanvasLayer/VBoxContainer/ShowPath.pressed = $Paths.get_children()[selected_player_idx+1].visible
	$CanvasLayer/VBoxContainer/ShowCollisions.pressed = $Collisions.get_children()[selected_player_idx+1].visible
	$CanvasLayer/VBoxContainer/ShowHeatmap.pressed = $Heatmaps.get_children()[selected_player_idx].visible

func generate_maze():
#		Create maze walls from graph
	for node in nodes:
		var x = node[0]
		var y = node[1]
		var room_x = x * (room_width)
		var room_y = y * (room_height)
		
		var passages = GameController.get_maze_node_passages(node)
		var has_right_passage = passages[0]
		var has_left_passage = passages[1]
		var has_top_passage = passages[2]
		var has_bottom_passage = passages[3]
		
		if not has_right_passage:
			walls_node.make_right_wall(room_x+room_width-1, room_y+1, room_height-1)
		if not has_left_passage:
			walls_node.make_left_wall(room_x, room_y+1, room_height-1)
		if not has_bottom_passage:
			if has_right_passage and has_left_passage:
				walls_node.make_straight_bottom_wall(room_x, room_y+room_height-1, room_width)
			else:
				if has_right_passage and not has_left_passage:
					walls_node.make_left_bottom_wall(room_x, room_y+room_height-1, room_width)
				elif has_left_passage and not has_right_passage:
					walls_node.make_right_bottom_wall(room_x, room_y+room_height-1, room_width)
				else:
					walls_node.make_bottom_wall(room_x, room_y+room_height-1, room_width)
		else:
			if has_right_passage:
				walls_node.make_wall(room_x+room_width-1, room_y+room_height-1, Vector2(1,5))
			if has_left_passage:
				walls_node.make_wall(room_x, room_y+room_height-1, Vector2(2,5))
		
		if not has_top_passage:
			if has_right_passage and has_left_passage:
				walls_node.make_straight_top_wall(room_x, room_y, room_width)
			else:
				if has_right_passage and not has_left_passage:
					walls_node.make_left_top_wall(room_x, room_y, room_width)
				elif not has_right_passage and has_left_passage:
					walls_node.make_right_top_wall(room_x, room_y, room_width)
				else:
					walls_node.make_top_wall(room_x, room_y, room_width)
		else:
			if not has_left_passage:
				walls_node.make_wall(room_x, room_y, Vector2(3,2))
			else:
				walls_node.make_wall(room_x, room_y, Vector2(2,3))
			if not has_right_passage:
				walls_node.make_wall(room_x+room_width-1, room_y, Vector2(2,2))
			else:
				walls_node.make_wall(room_x+room_width-1, room_y, Vector2(1,3))

func generate_collisions():
	var collisions: Array = GameController.get_analyzed_collisions()
	var last_collision
	for i in collisions.size():
		
		var new_player_collisions_group = Node2D.new()
		new_player_collisions_group.name = "Player%d" % i
		new_player_collisions_group.visible = false
		$Collisions.add_child(new_player_collisions_group)
		
		for _collision in collisions[i]:
			if _collision == last_collision:
				continue
			
			var new_collision = collision.duplicate()
			new_collision.color = colors[i]
			new_collision.rect_position = _collision
			new_player_collisions_group.add_child(new_collision)
			new_collision.visible = true
			
			last_collision = _collision
		
	

func generate_heatmap():
	var heatmaps = GameController.get_analyzed_heatmaps()
	for i in heatmaps.size():
		var new_player_heatmap_group = Node2D.new()
		new_player_heatmap_group.name = "Player%d" % i
		new_player_heatmap_group.visible = false
		$Heatmaps.add_child(new_player_heatmap_group)
		
#		Get max # of passes 
		var _max: float = 0
		for room in heatmaps[i]:
			var amount : float = heatmaps[i][room]
			_max = max(amount, _max)
		
		for room in heatmaps[i]:
			var amount = heatmaps[i][room]
			
			var new_heatmap_region = ColorRect.new()
			new_heatmap_region.color = colors[i]
			new_heatmap_region.rect_position = Vector2(room[0] * GameController.room_width * 16, room[1] * GameController.room_height * 16)
			new_heatmap_region.rect_size = Vector2(GameController.room_width * 16, GameController.room_height * 16)
			new_heatmap_region.mouse_filter = Control.MOUSE_FILTER_IGNORE
			new_player_heatmap_group.add_child(new_heatmap_region)
			
			var new_amount_passed = Label.new()
			new_amount_passed.text = str(amount)
			new_heatmap_region.add_child(new_amount_passed)
			
			new_heatmap_region.color.a = (amount / _max)
			
		
	

func _on_Button_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Analysis"))

func _toggle_visible(node:Node2D):
	node.visible = not node.visible

func _on_ShowPath_pressed():
	_toggle_visible($Paths.get_children()[selected_player_idx+1])

func _on_ShowCollisions_pressed():
	_toggle_visible($Collisions.get_children()[selected_player_idx+1])

func _on_ShowHeatmap_pressed():
	_toggle_visible($Heatmaps.get_children()[selected_player_idx])
