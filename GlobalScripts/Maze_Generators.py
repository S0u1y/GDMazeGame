import math

import networkx as nx

import random


class MazeAlgorithm:
	def generate(self, maze):
		pass

class MazeAlgorithms:
	algorithms = {}
	
	def add(self, key, algorithm):
		if not issubclass(algorithm, MazeAlgorithm):
			print("Cannot add algorithm, because it is not subclass of a maze algorithm!")
			return
		
		self.algorithms[key] = algorithm
	
	def use(self, key):
		if key in self.algorithms:
			return self.algorithms[key]
		return None
	
	def get_keys(self):
		return list(self.algorithms.keys())

# returns coordinates of cardinal neighbours
def get_surrounding_cells_coordinates(point):
	crds = [(1, 0), (-1, 0), (0, 1), (0, -1)]
	return [(c[0]+point[0], c[1]+point[1]) for c in crds]


class RecursiveBackTracker(MazeAlgorithm):
	def __init__(self, starting_node=None):
		if starting_node is None:
			self.starting_cell = (0, 0)
		else:
			self.starting_cell = starting_node

	def generate(self, maze):
		if maze.G is None:
			maze.G = nx.empty_graph([(y, x) for x in range(maze.width) for y in range(maze.height)])
		
		stack = []
		nodes = dict(maze.G.nodes)
		stack.append(self.starting_cell)
		nodes[self.starting_cell] = "visited"
		while len(stack) > 0:
			current_cell = stack.pop()
			surrounding_cells = get_surrounding_cells_coordinates(current_cell)
			nodes_with_unvisited_neighbours = [cell for cell in surrounding_cells if cell in nodes and nodes[cell] != "visited"]
			if len(nodes_with_unvisited_neighbours) > 0:
				stack.append(current_cell)
				to_carve = random.choice(nodes_with_unvisited_neighbours)
				stack.append(to_carve)
				maze.G.add_edge(to_carve, current_cell)
				nodes[to_carve] = "visited"


class CompletelyRandomGenerator(MazeAlgorithm):
	def generate(self, maze):
		if maze.G is None:
			maze.G = nx.empty_graph([(y, x) for x in range(maze.width) for y in range(maze.height)])
		
		# randomly assign edges in graph
		for node in G.nodes():
			choice = random.choice([[-1, 0], [1, 0], [0, 1], [0, -1], [0, 0]])
			
			if node[0] == 0 and choice[0] == -1:
				choice[0] = random.randint(0, 1)
			elif node[0] == 10 and choice[0] == 1:
				choice[0] = random.randint(-1, 0)
			
			if node[1] == 0 and choice[1] == -1:
				choice[1] = random.randint(0, 1)
			elif node[1] == 20 and choice[1] == 1:
				choice[1] = random.randint(-1, 0)
			
			if (choice[0], choice[1]) in ((1, 1), (-1, -1), (-1, 1), (1, -1)):
				if random.randint(0, 1) > 0:
					choice[0] = 0
				else:
					choice[1] = 0
			
			if (0, 0) != (choice[0], choice[1]):
				G.add_edge(node, (node[0] + choice[0], node[1] + choice[1]))


class TruePrimsMST(MazeAlgorithm):
	def __init__(self, starting_node=(0, 0)):
		self.starting_node = starting_node

	def generate(self, maze):
		if maze.G is None:
			maze.G = nx.grid_2d_graph(maze.height, maze.width)
		
		for i in maze.G.edges():
			maze.G[i[0]][i[1]]['weight'] = random.randint(1, 10)

		edge = {}
		cost = {}
		for node in maze.G.nodes():
			cost[node] = math.inf
			edge[node] = None

		cost[self.starting_node] = 0
		TEMP = list(maze.G.nodes()).copy()
		T = []
		while len(TEMP) != 0:
			v = min(cost, key=cost.get)
			TEMP.remove(v)
			if edge[v] is not None:
				T.append(edge[v])
			for neighbor in maze.G.neighbors(v):
				if neighbor in TEMP and cost[neighbor] > maze.G[v][neighbor]["weight"]:
					cost[neighbor] = maze.G[v][neighbor]["weight"]
					edge[neighbor] = (v, neighbor)

			del cost[v]
			# del edge[v]

		maze.G = nx.Graph(T)


class SimplifiedPrim(MazeAlgorithm):

	def __init__(self, starting_node=None):
		super().__init__()
		self.width = None
		self.height = None
		self.starting_cell = starting_node
			

	def generate(self, maze):
		self.width = maze.width - 1
		self.height = maze.height - 1
		if maze.G is None:
			maze.G = nx.empty_graph([(y, x) for x in range(maze.width) for y in range(maze.height)])
		
		if self.starting_cell is None:
			self.starting_cell = (random.randint(0, self.width), random.randint(0, self.height))
			
		inside_cells = [
			self.starting_cell
		]
		frontier_cells = [cell for cell in self.getSurroundingCells(self.starting_cell) if cell not in inside_cells]

		while len(frontier_cells) > 0:
			cF = random.choice(frontier_cells)
			around_cF = self.getSurroundingCells(cF)
			cI = random.choice([cell for cell in around_cF if cell in inside_cells])
			inside_cells.append(cF)
			[frontier_cells.append(cell) for cell in around_cF if cell not in (*inside_cells, *frontier_cells)]
			nx.add_path(maze.G, (self.reverseTuple(cF), self.reverseTuple(cI)))
			frontier_cells.remove(cF)

	def getSurroundingCells(self, position):
		output = []
		if position[0] + 1 <= self.width:
			output.append((position[0] + 1, position[1]))
		if position[0] - 1 >= 0:
			output.append((position[0] - 1, position[1]))
		if position[1] + 1 <= self.height:
			output.append((position[0], position[1] + 1))
		if position[1] - 1 >= 0:
			output.append((position[0], position[1] - 1))

		return output

	def reverseTuple(self, _tuple):
		return _tuple[1], _tuple[0]

maze_algorithms = MazeAlgorithms()
maze_algorithms.add("RecursiveBackTracker", RecursiveBackTracker)
maze_algorithms.add("TruePrimsMST", TruePrimsMST)
maze_algorithms.add("SimplifiedPrim", SimplifiedPrim)
