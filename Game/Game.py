from godot import exposed, export, Array, Node2D, TileMap, NodePath, Color, ResourceLoader, GDString
from godot import *

import random

gold_coin = ResourceLoader.load("res://PickupableItems/GoldCoin.tscn")

GameControllerNode = None

# TODO: add score based on collected items and time

# zásady komentování kódu

@exposed
class Game(Node2D):	
	def _ready(self):
#		We CAN get the node, but everything we want to get HAS to be exported by the node, therefore it has to be a godot variant..
		global GameControllerNode 
		GameControllerNode = self.get_node("/root/GameController")
		
		self.objects = Array()
		
		self.n_cols = GameControllerNode.n_cols
		self.n_rows = GameControllerNode.n_rows
		self.room_width = GameControllerNode.room_width
		self.room_height = GameControllerNode.room_height
		
		self.walls_node = self.get_node("Walls")
		self.floor_node = self.get_node("Floor")
		
		self.generated_rooms = []
		self.free_cells = []
		self.occupied_cells = []
		
		
		self.generate_maze()
	
#	For generating chunks around player / entities.
#	works only if world_gen is set to "Chunked"
	def generate_chunk(self, center_node):
		chunk_radius = 2
		for x in range(chunk_radius+1):
			for y in range(chunk_radius+1):
				self.generate_room(Array([center_node[0]+x, center_node[1]-y]))
				self.generate_room(Array([center_node[0]-x, center_node[1]+y]))
				self.generate_room(Array([center_node[0]+x, center_node[1]+y]))
				self.generate_room(Array([center_node[0]-x, center_node[1]-y]))
		
		if self.free_cells == []:
			return
		
#		Spawn Coins/pickupables
		coins_to_chunks_ratio = (self.n_rows * self.n_cols) / self.coins_amount
		n_coins_to_generate = random.randint(math.floor(coins_to_chunks_ratio), math.ceil(coins_to_chunks_ratio))
		self.coins_to_generate -= n_coins_to_generate
		if self.coins_to_generate < 0:
			return
		
		for i in range(n_coins_to_generate):
			self.spawn_coin()
		
#		Remove old cells from future generation
		self.free_cells = []
		self.occupied_cells = []
	

	def generate_room(self, node):
		if node in self.generated_rooms:
			return
		
		self.generated_rooms.append(node)
		
		has_right_passage, has_left_passage, has_top_passage, has_bottom_passage = GameControllerNode.get_maze_node_passages(node)
		if has_right_passage is None:
			return
		
		
		x = node[0]
		y = node[1]
		room_x = x * (self.room_width)
		room_y = y * (self.room_height)
		
#		Create floor
		for _y in range(self.room_height):
			for _x in range(self.room_width):
				self.floor_node.set_cell(_x + room_x,_y + room_y,0,Vector2(0,0))
				self.free_cells.append(Array([_x + room_x,_y + room_y]))
		
		if not has_right_passage:
			self.walls_node.make_right_wall(room_x+self.room_width-1, room_y+1, self.room_height-1)
		if not has_left_passage:
			self.walls_node.make_left_wall(room_x, room_y+1, self.room_height-1)
		
		if not has_bottom_passage:
			if has_right_passage:
				if has_left_passage:
					self.walls_node.make_straight_bottom_wall(room_x, room_y+self.room_height-1, self.room_width)
				else:
					self.walls_node.make_left_bottom_wall(room_x, room_y+self.room_height-1, self.room_width)
			else:
				if has_left_passage:
					self.walls_node.make_right_bottom_wall(room_x, room_y+self.room_height-1, self.room_width)
				else:
					self.walls_node.make_bottom_wall(room_x, room_y+self.room_height-1, self.room_width)
		else:
			if has_right_passage:
				self.walls_node.make_wall(room_x+self.room_width-1, room_y+self.room_height-1, Vector2(1,5))
			if has_left_passage:
				self.walls_node.make_wall(room_x, room_y+self.room_height-1, Vector2(2,5))
		
		if not has_top_passage:
			if has_right_passage:
				if has_left_passage:
					self.walls_node.make_straight_top_wall(room_x, room_y, self.room_width)
				else:
					self.walls_node.make_left_top_wall(room_x, room_y, self.room_width)
			else:
				if has_left_passage:
					self.walls_node.make_right_top_wall(room_x, room_y, self.room_width)
				else:
					self.walls_node.make_top_wall(room_x, room_y, self.room_width)
		else:
			if not has_left_passage:
				self.walls_node.make_wall(room_x, room_y, Vector2(3,2))
			else:
				self.walls_node.make_wall(room_x, room_y, Vector2(2,3))
			if not has_right_passage:
				self.walls_node.make_wall(room_x+self.room_width-1, room_y, Vector2(2,2))
			else:
				self.walls_node.make_wall(room_x+self.room_width-1, room_y, Vector2(1,3))
		
	
	def generate_rooms(self, nodes):
		for node in nodes:
			self.generate_room(node)
		
		for i in range(self.coins_amount):
			self.spawn_coin()

	def generate_maze(self):
		nodes = GameControllerNode.get_maze_nodes()
		
#		Set coin amount
		self.coins_amount = int((self.room_width * self.room_height * self.n_cols * self.n_rows) * (random.randint(5, 7)/1000))
		self.coins_to_generate = self.coins_amount
		
		if GameControllerNode.world_gen == GDString("Entire World"):
			self.generate_rooms(nodes)
		
#		Spawn treasure
		treasure_node = nodes[-1] if str(GameControllerNode.game_type) == "Single" else (self.n_cols/2, self.n_rows/2)
		treasure_location = [(treasure_node[0] * self.room_width * 16) + self.room_width*8, (treasure_node[1] * self.room_height * 16) + self.room_height*8]
		treasure_chest = self.get_node("Treasure")
		treasure_chest.position = Vector2(treasure_location[0], treasure_location[1])
		self.objects.append(treasure_chest)

		starting_node = nodes[-2]
		self.get_node("Player1").position = Vector2((starting_node[0] * self.room_width * 16) + self.room_width*8, (starting_node[1] * self.room_height * 16) + self.room_height*8)
		if str(GameControllerNode.game_type) == "Multi":
			last_node = nodes[-1]
			self.get_node("Player2").position = Vector2((last_node[0] * self.room_width * 16) + self.room_width*8, (last_node[1] * self.room_height * 16) + self.room_height*8)
		
	
	#	Appending is much faster than removing.
	def remove_free_cell(self, arr):
		try:
			self.occupied_cells.append(arr)
		except:
			pass
	
	
	def spawn_coin(self):
		picked_cell_idx = random.randint(0, len(self.free_cells)-1)
		picked_pos = self.free_cells.pop(picked_cell_idx)
#		It is much faster to check a smaller list and recursively try to spawn a coin again.
		if picked_pos in self.occupied_cells:
			self.spawn_coin()
			return
		
		new_coin = gold_coin.instance()
		self.get_node("Pickupables").add_child(new_coin)
		new_coin.position = self.floor_node.map_to_world(Vector2(picked_pos[0], picked_pos[1])) + Vector2(random.randint(4,14),random.randint(4,14))
	
