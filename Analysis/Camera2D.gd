extends Camera2D

var is_dragging = false
var starting_mouse_pos = Vector2.ZERO
var starting_camera_pos = Vector2.ZERO

var zoom_amount = Vector2(0.05, 0.05)

func _ready():
	pass 

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT or event.button_mask == BUTTON_MASK_MIDDLE:
			position -= event.relative * zoom
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			if zoom - zoom_amount > Vector2(0.5,0.5):
				zoom -= zoom_amount
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom += zoom_amount
