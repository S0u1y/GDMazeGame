extends Node2D

func _ready():
	pass 

func _draw():

	var movement: Array = GameController.get_analyzed_movement()
	var movement_size = movement.size()

	for i in movement_size-1:
		draw_line(movement[i], movement[i+1], Color(255,255,255), 5)

	pass
