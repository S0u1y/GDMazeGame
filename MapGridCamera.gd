extends Camera2D

var is_dragging = false
var starting_mouse_pos = Vector2.ZERO
var starting_camera_pos = Vector2.ZERO

func _ready():
	pass 

func _unhandled_input(event):
	if event is InputEventMouseMotion and $"../../../..".showing_map:
		if event.button_mask == BUTTON_MASK_LEFT or event.button_mask == BUTTON_MASK_MIDDLE:
			position -= event.relative / zoom
