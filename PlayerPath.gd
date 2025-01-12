extends Node2D

var colors = [
	Color(128, 0, 0),
	Color(0, 0, 128)
]

func _draw():

	var movements: Array = GameController.get_analyzed_movement()
	for i in movements.size():
		var movement = movements[i]
		var movement_size = movement.size()
		
		for j in movement_size-1:
			draw_line(movement[j], movement[j+1], colors[i], 5)
		
	
