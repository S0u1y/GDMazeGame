extends KinematicBody2D

export var move_speed: float = 100

var coins = 0
var score = 0

onready var game_node = self.get_parent()

onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")
var velocity: Vector2

onready var map = $"../MapGrid"
onready var walls_node = $"../Walls"

func _ready():
	update_animation_parameters(Vector2(0, -1.1))

var tick_count = 0

func _physics_process(_delta):
	var input_direction = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		)	
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction * move_speed
	move_and_slide(self.velocity)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if not collision:
			continue
		var collider = collision.collider
		if collider is TileMap and collider.name == "Walls":
			game_node.player_collided(collision.collider, collision.position)
	
	
	pick_state()
	
	map.update_player_position(map.world_to_map_position(self.position.x, self.position.y))
	
	tick_count +=1
	if tick_count > 20:
		tick_count = 0
		GameController.analyze_movement(self.position.x, self.position.y)

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input)
		

func pick_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
