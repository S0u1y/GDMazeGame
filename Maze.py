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

	#	matplotlib draw function
	#	def draw_maze(self, offset=None):
	#		# display position with inverted Y ( [0,0] is in top left corner of graph, [n-1,n-1] in the right bottom )
	#		if offset is None:
	#			offset = [0, 0]
	#		pos = {node: (node[0] + offset[0], -node[1] + offset[1]) for node in self.G.nodes()}
	#		nx.draw(self.G, pos=pos, with_labels=False, node_size=10)

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
