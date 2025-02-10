import pickle

import networkx as nx


# TODO: Finish load and save
class Maze:
	def __init__(self, width, height, maze_algorithm_type):
		G = None
		
		self.G = G
		self.width = width
		self.height = height
		
		self.generate(maze_algorithm_type)
	
	def generate(self, maze_algorithm_type):
		if self.G is not None:
			return False
		
		maze_algorithm_type.generate(self)
		
		return True
	
	def save(self, filename):
		with open(filename, "wb") as output:
			pickle.dump(self, output, pickle.HIGHEST_PROTOCOL)
	
	def load(self, filename):
		with open(filename, "rb") as _input:
			loaded = pickle.load(_input)
		
		return loaded
	
	def loads(self, filename):
		with open(filename, "rb") as _input:
			self = pickle.load(_input)
	

def load_maze(filename):
	with open(filename, "rb") as _input:
		loaded = pickle.load(_input)
	
	return loaded
