import pickle
import time

# Class that holds analysis for the player collisions, movement and heatmap
class Analyzer:
	def __init__(self):
		self.start_time = time.time()
		
		self.movement = []
		self.last_move = None

		self.collisions = []
		self.last_collision = None

		self.heatmap = {}
		self.last_room = None

	def analyze_movement(self, x, y):
		if self.last_move != (x, y):
			self.movement.append((x, y))
	
	
	def analyze_collisions(self, world_x, world_y, wall_x, wall_y):
		pass

	def analyze_heatmap(self, room_x, room_y):
		room = (room_x, room_y)
		if self.last_room != room:
			if room in self.heatmap:
				self.heatmap[room] += 1
			else:
				self.heatmap[room] = 1

	def save(self, location):
		_time = time.time() - self.start_time
		with open(f"{location}/Analysis", "wb") as output:
			pickle.dump({
				"movement": self.movement,
				"heatmap": self.heatmap,
				"collisions": self.collisions,
				"time": _time
			}, output, pickle.HIGHEST_PROTOCOL)
		
	def load(self, filename):
		with open(filename, "rb") as _input:
			loaded = pickle.load(_input)
			self.movement = loaded["movement"]
			self.heatmap = loaded["heatmap"]
			self.collisions = loaded["collisions"]
			self.time = loaded["time"]
