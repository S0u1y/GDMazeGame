from godot import exposed, export, Array, Node2D, TileMap, NodePath, Color, ResourceLoader
from godot import *

import random

gold_coin = ResourceLoader.load("res://PickupableItems/GoldCoin.tscn")

GameControllerNode = None

# TODO: add coins, keys or collectable items
#		add score based on collected items

# zásady komentování kódu
# kouknout na zmeny v sablone latexu jestli neni zmena ve vyhlášeních a popřípadě změnit

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
		
		self.free_cells = []
		
		self.generate_maze()
#		TODO: 	generate coins randomly on map
#				amount of coins is based on difficulty

	def player_collided(self, collider, position):
#		Gets the exact cell position the player collides with
		local_position = collider.world_to_map(position)
		room_index = [int (local_position.x/self.room_width), int (local_position.y/self.room_height)]
#		print("position:", local_position, "room:", room_index)

	def generate_maze(self):
		nodes = GameControllerNode.get_maze_nodes()
		
		for node in nodes:
			
			has_right_passage, has_left_passage, has_top_passage, has_bottom_passage = GameControllerNode.get_maze_node_passages(node)
			
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
		
#		Spawn coins
		coins_amount = int(len(self.free_cells) * (random.randint(5, 7)/1000))
		for i in range(coins_amount):
			new_coin = gold_coin.instance()
			self.get_node("Pickupables").add_child(new_coin)
			
			picked_cell_idx = random.randint(0, len(self.free_cells)-1)
			picked_pos = self.free_cells.pop(picked_cell_idx)
			new_coin.position = self.floor_node.map_to_world(Vector2(picked_pos[0], picked_pos[1])) + Vector2(random.randint(4,14),random.randint(4,14))
	
	def remove_free_cell(self, arr):
		try:
			self.free_cells.remove(arr)
		except:
			pass
