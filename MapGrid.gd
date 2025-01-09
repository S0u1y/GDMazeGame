extends CanvasLayer

export var minimap_size: Vector2 = Vector2(60,60)

onready var game_node = $"%Game"
onready var walls_node = $"%Walls"
onready var pause_menu = $"%PauseMenu"

onready var tile_map = $ViewportContainer/Viewport/TileMap
onready var player_rect = $ViewportContainer/Viewport/PlayerRect
onready var viewport_container = $ViewportContainer
onready var viewport = $ViewportContainer/Viewport

var map_scale = null
var showing_map = false

	

func _ready():
	viewport.size = minimap_size
	viewport_container.rect_size = viewport.size
	viewport_container.set_anchors_and_margins_preset(viewport_container.PRESET_TOP_RIGHT)
	
#	at least one variable needs to be float in division, so GDScript doesn't count it as an int division with no remainder.
	var room_width = float (GameController.room_width)
	var room_height = float (GameController.room_height)
	if room_width / room_height == 1:
		tile_map.set_scale(Vector2(1,1))
	elif room_width / room_height > 1:
		tile_map.set_scale(Vector2(room_width / room_height, 1))
	else:
		tile_map.set_scale(Vector2(1, room_height / room_width))
	
	map_scale = tile_map.transform.get_scale()
	if not game_node.is_node_ready():
		yield(game_node, "ready")
	for node in GameController.get_maze_nodes():
		var node_passages = GameController.get_maze_node_passages(node)
		generate_cell(node[0],node[1],len(GameController.get_maze_node_edges(node)), node_passages)
	

func _process(_delta):
	if Input.is_action_just_pressed("toggle_map"):
		toggle_map()

func make_wall(x,y,tile_coord):
	GameController.make_tile_cell(tile_map, x, y, tile_coord)

func generate_cell(x, y, n_edges, passages_arr):
	var has_right_passage = passages_arr[0]
	var has_left_passage = passages_arr[1]
	var has_top_passage = passages_arr[2]
	var has_bottom_passage = passages_arr[3]
	
	
	if n_edges == 1:
		if has_top_passage:
			self.make_wall(x,y,Vector2(2,0))
		elif has_right_passage:
			self.make_wall(x,y,Vector2(3,0))
		elif has_bottom_passage:
			self.make_wall(x,y,Vector2(0,0))
		elif has_left_passage:
			self.make_wall(x,y,Vector2(1,0))
	elif n_edges == 2:
		if has_top_passage:
			if has_bottom_passage:
				self.make_wall(x,y,Vector2(0,2))
			elif has_right_passage:
				self.make_wall(x,y,Vector2(0,1))
			elif has_left_passage:
				self.make_wall(x,y,Vector2(3,1))
		elif has_right_passage:
			if has_bottom_passage:
				self.make_wall(x,y,Vector2(1,1))
			if has_left_passage:
				self.make_wall(x,y,Vector2(1,2))
		elif has_bottom_passage:
			self.make_wall(x,y,Vector2(2,1))
	elif n_edges == 3:
		if not has_top_passage:
			self.make_wall(x,y,Vector2(0,3))
		elif not has_right_passage:
			self.make_wall(x,y,Vector2(2,3))
		elif not has_bottom_passage:
			self.make_wall(x,y,Vector2(1,3))
		else:
			self.make_wall(x,y,Vector2(3,3))
	else:
		self.make_wall(x,y,Vector2(2,2))

func add_indicator(x, y, color: Color):
	var new_rect = ColorRect.new()
	new_rect.rect_size = Vector2(16,16)
	new_rect.color = color
	new_rect.rect_position = world_to_map_position(x, y) - new_rect.rect_size/2
	viewport.add_child(new_rect)

#divide position by (room_width/height * cell size) and then multiply by the map's cell size.
func world_to_map_position(x, y) -> Vector2:
	return Vector2(x / (GameController.room_width*walls_node.cell_size.x) * tile_map.cell_size.x * map_scale.x, y / (GameController.room_height*walls_node.cell_size.y) * tile_map.cell_size.y * map_scale.y)

func update_player_position(position:Vector2):
	player_rect.rect_position = position - player_rect.rect_size/2

func switch_camera():
	tile_map.get_node("Camera2D").current = showing_map
	player_rect.get_node("Camera2D").current = not showing_map

#TODO: Make function to show entire map
func toggle_map():
#	var n_cols = game_node.n_cols
#	var n_rows = game_node.n_rows
#	var width = tile_map.cell_size.x
#	var height = tile_map.cell_size.y
	
	showing_map = not showing_map
	
	if showing_map:
#		if pause_menu.visible:
#			pause_menu.toggle_menu()
		
#		TODO: Get this value from project settings
		viewport.size = Vector2(1024,600)
		viewport_container.set_anchors_and_margins_preset(viewport_container.PRESET_WIDE)

		switch_camera()
#		tile_map.get_node("Camera2D").offset = Vector2(n_cols * width * map_scale.x, n_rows * height * map_scale.y)/2
		tile_map.get_node("Camera2D").position = player_rect.rect_position - player_rect.rect_size/2
	else:
		viewport.size = minimap_size
		viewport_container.set_anchors_and_margins_preset(viewport_container.PRESET_TOP_RIGHT)
		
		switch_camera()
	


#TODO: Make functions to zoom or move camera in minimap
