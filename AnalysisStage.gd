extends Node2D

var nodes = GameController.get_maze_nodes()

var n_cols = GameController.n_cols
var n_rows = GameController.n_rows
var room_width = GameController.room_width
var room_height = GameController.room_height

onready var walls_node:TileMap = $Walls

func _ready():
	generate_maze()

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


func _on_Button_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Analysis"))
