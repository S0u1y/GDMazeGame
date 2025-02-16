extends TileMap

var game_node = null

func _ready():
	if get_tree().root.get_children()[-1].name != "AnalysisStage":
		game_node = get_node("%Game")

var torch = preload("res://Decorations/Torch.tscn")


func make_room(x,y,width,height):
	make_top_wall(x,y,width)
	make_left_wall(x,y+1,height)
	make_right_wall(x+width-1,y+1,height)
	make_bottom_wall(x,y+height-1,width)
		
func make_wall(x,y,tile_coord):
	GameController.make_tile_cell(self, x, y, tile_coord)
	if game_node:
		game_node.remove_free_cell([x,y])

# different types of top walls
var top_walls = [
	Vector2(0, 0),
	Vector2(1, 0),
	Vector2(2, 0),
	Vector2(3, 0),
	Vector2(0, 1),
	Vector2(1, 1),
	Vector2(2, 1),
]

# top walls weighted for picking random walls when generating maze
var weighted_top_walls = [
	top_walls[0],
	top_walls[0],
	top_walls[0],
	top_walls[0],
	top_walls[0],
	top_walls[0],
	top_walls[0],
	top_walls[0],
	top_walls[0],
	top_walls[0],
	top_walls[1],
	top_walls[2],
	top_walls[3],
	top_walls[4],
	top_walls[5],
	top_walls[6],
]

var generated_top_wall_cnt = 0
# generate top walls and possible decorations on them
func _generate_top_walls(x,y, width):
	for wall_i in width:
		var pick_wall = weighted_top_walls.pick_random()
		make_wall(x+wall_i,y,pick_wall)
		
		if not game_node:
			continue
		
		if [0, width - 1].find(wall_i) == - 1 and generated_top_wall_cnt % 3 == 0 and pick_wall == top_walls[0]:
			var world_pos = map_to_world(Vector2(x+wall_i,y))
			var new_torch = torch.instance()
			$"../Decorations".add_child(new_torch)
			new_torch.position = world_pos + Vector2(8,8)
		
		generated_top_wall_cnt += 1

func make_top_wall(x, y, width):
	_generate_top_walls(x,y,width)
	make_wall(x,y,Vector2(0,2))
	make_wall(x+width-1,y,Vector2(3,1))

func make_left_top_wall(x, y, width):
	_generate_top_walls(x,y,width)
	make_wall(x,y,Vector2(0,2))

func make_right_top_wall(x, y, width):
	_generate_top_walls(x,y,width)
	make_wall(x+width-1,y,Vector2(3,1))

func make_straight_top_wall(x, y, width):
	_generate_top_walls(x,y,width)

func make_left_wall(x,y,height):
	for wall_i in height:
		make_wall(x, y+wall_i, Vector2(3,2))

func make_right_wall(x,y,height):
	for wall_i in height:
		make_wall(x, y+wall_i, Vector2(2,2))

func make_straight_bottom_wall(x,y,width):
	for wall_i in width:
		make_wall(x+wall_i,y,Vector2(0,4))

func make_bottom_wall(x,y,width):
	for wall_i in width:
		make_wall(x+wall_i,y,Vector2(0,4))
	make_wall(x,y,Vector2(3,4))
	make_wall(x+width-1,y,Vector2(0,5))

func make_right_bottom_wall(x,y,width):
	for wall_i in width:
		make_wall(x+wall_i,y,Vector2(0,4))
	make_wall(x+width-1,y,Vector2(0,5))

func make_left_bottom_wall(x,y,width):
	for wall_i in width:
		make_wall(x+wall_i,y,Vector2(0,4))
	make_wall(x,y,Vector2(3,4))

func make_bottom_aligned_wall(x,y,width):
	for wall_i in width:
		set_cell(x+wall_i, y, 0, false, true, true, Vector2(3,2))
		if game_node:
			game_node.remove_free_cell([x,y])
