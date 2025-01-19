extends TileMap

func make_room(x,y,width,height):
	make_top_wall(x,y,width)
	make_left_wall(x,y+1,height)
	make_right_wall(x+width-1,y+1,height)
	make_bottom_wall(x,y+height-1,width)
		
func make_wall(x,y,tile_coord):
	GameController.make_tile_cell(self, x, y, tile_coord)

func make_top_wall( x, y, width):
	for wall_i in width:
		make_wall(x+wall_i,y,Vector2(0,0))
	make_wall(x,y,Vector2(0,2))
	make_wall(x+width-1,y,Vector2(3,1))

func make_left_top_wall(x, y, width):
	for wall_i in width:
		make_wall(x+wall_i,y,Vector2(0,0))
	make_wall(x,y,Vector2(0,2))

func make_right_top_wall(x, y, width):
	for wall_i in width:
		make_wall(x+wall_i,y,Vector2(0,0))
	make_wall(x+width-1,y,Vector2(3,1))

func make_straight_top_wall(x, y, width):
	for wall_i in width:
		make_wall(x+wall_i,y,Vector2(0,0))

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
