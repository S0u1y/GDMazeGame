from godot import exposed, export, Vector2, TileMap, Node2D, Array
from godot.bindings import *

import os
import time
import datetime
import csv

import pickle

from Maze import Maze, load_maze
from Maze_Generators import *
from Analyzer import Analyzer

USER_LOCATION = str(ProjectSettings.globalize_path("user://"))

# TODO: set main game settings in here
@exposed
class GameController(Node):
#	GDScript can't see maze as maze, so it should be accessed through some getter
	_maze: Maze = None
	chosen_algorithm = export(str, "TruePrimsMST") 
	game_difficulty = export(str)
	game_state = ""
	
	loaded_maze_location = export(str)
	
	n_cols = export(int)
	n_rows = export(int)
	room_width = export(int, 10)
	room_height = export(int, 10)
	
	_analyzer: Analyzer = None
	
	saves_folder = USER_LOCATION + "/saves/"
	
	paused = False
	
	def _ready(self):
		self._analyzer = Analyzer()
	
		self.make_folder()
		self.make_folder("analysis")
		self.make_folder("data")
	
#	TODO: handle permission error and other errors but skip fileExists err.
	def make_folder(self, name:str=""):
		try:
			os.mkdir(self.saves_folder+name)
		except FileExistsError:
			pass
		except PermissionError:
			error("A permissions error has occured")
		except Exception as e:
			error("An error occured:", e)
	
#	Called when we need to reset game state
	def initialize_new_game(self):
		self.loaded_maze_location = ""
		self._analyzer = Analyzer()
		self._analyzer.reset_timer()
		self.paused = False
	
#	Called when all settings for creating a maze are set
	def create_maze(self):
		self._maze = Maze(self.n_cols, self.n_rows, maze_algorithms.use(str(self.chosen_algorithm))())
		nx.add_path(self._maze.G, ((0,-1), (0,0)))
		nx.add_path(self._maze.G, ((self.n_cols-1, self.n_rows-1), (self.n_cols-1, self.n_rows)))
#		IF the game is multiplayer then make one of the middle cells the last cell (the last cell in nodes list = treasure cell.)
	
	def get_maze_algorithms(self):
		return maze_algorithms.get_keys()
	
	def get_analyzed_movement(self):
		movement = self._analyzer.movement
		gd_movement = Array()
		for move in movement:
			gd_movement.append(Vector2(move[0], move[1]))
		
		return gd_movement
	
	def save_game(self):
		current_time = datetime.datetime.now()
		tail = f"{current_time.year}-{current_time.month}-{current_time.day} {current_time.hour}-{current_time.minute}-{current_time.second}"
		new_folder_location = f"{self.saves_folder}/analysis/{tail}"
		os.mkdir(new_folder_location)
		
		self._maze.save(f"{new_folder_location}/Maze")
		self._analyzer.save(new_folder_location)
		
		with open(f"{new_folder_location}/settings", "wb") as output:
			pickle.dump({
				"n_cols": self.n_cols,
				"n_rows": self.n_rows,
				"room_width": self.room_width,
				"room_height": self.room_height,
			}, output, pickle.HIGHEST_PROTOCOL)
	
	def load_game(self, game_folder):
		if self.loaded_maze_location in (None, ""):
			self.loaded_maze_location = game_folder
		
		self._maze = load_maze(f"{game_folder}/Maze")
		self._analyzer.load(f"{game_folder}/Analysis")
		
		with open(f"{game_folder}/settings", "rb") as _input:
			loaded = pickle.load(_input)
			self.n_cols = loaded["n_cols"]
			self.n_rows = loaded["n_rows"]
			self.room_width = loaded["room_width"]
			self.room_height = loaded["room_height"]
		
	
#	Getter functions work only (or mainly) assuming they get gdvariant input
	def get_maze_edges(self):
		return self.to_gd(list(self._maze.G.edges))
	
	def get_maze_nodes(self):
		return self.to_gd(list(self._maze.G.nodes))
	
	def get_maze_node(self, idx):
		return self.to_gd(list(self._maze.G.nodes)[idx])
	
	def get_maze_node_edges(self, node):
		return self.to_gd(list(self._maze.G[tuple(node)]))
	
	def get_maze_node_passages(self, node):
		edges = self._maze.G[tuple(node)]
		
		has_right_passage = False
		has_left_passage = False
		has_top_passage = False
		has_bottom_passage = False
		
		x = node[0]
		y = node[1]
		for edge in edges:
			if edge[0] == x or edge[1] == y:
				if edge[0] > x:
					has_right_passage = True
				elif edge[0] < x:
					has_left_passage = True
				if edge[1] > y:
					has_bottom_passage = True
				elif edge[1] < y:
					has_top_passage = True
		
		return Array([has_right_passage, has_left_passage, has_top_passage, has_bottom_passage])
	
	def get_time(self):
		return self.to_gd(self._analyzer._time)
	
	
	def toggle_pause_game(self):
		self.paused = not self.paused
		self.toggle_pause_timer()
	
	def toggle_pause_timer(self):
		self._analyzer.toggle_pause_timer()
	
	def make_tile_cell(self, tile_map:TileMap, x, y, autotile_coord:Vector2):
		tile_map.set_cell(x,y,0,autotile_coord=autotile_coord)

	def analyze_movement(self, player_x, player_y):
		self._analyzer.analyze_movement(player_x, player_y)

	def analyze_collisions(self, world_x, world_y, wall_x, wall_y):
		self._analyzer.analyze_collision(world_x, world_y, wall_x, wall_y)

	def to_gd(self, var):
		if isinstance(var, (list, tuple)):
			return Array([self.to_gd(item) for item in var])
		elif isinstance(var, dict):
			return Dictionary({self.to_gd(key): self.to_gd(value) for key, value in var.items()})
		
		return var

#self = GameController
