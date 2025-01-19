extends Node2D

var movements
var color

func _draw():
	draw_path(movements, color)

func draw_path(_movements, _color):
	var movement_size = _movements.size()
	
	for i in movement_size-1:
		draw_line(_movements[i], _movements[i+1], _color, 5)
