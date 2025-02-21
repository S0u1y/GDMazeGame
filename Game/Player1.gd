extends KinematicBody2D
class_name Player

export var move_speed: float = 100
var running = false

export var controls: Resource = null
var player_controls: PlayerControls

var coins = 0
var score = 0

onready var hat = $Hat
onready var clothes = $Clothes

onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")

var velocity: Vector2

signal player_moved
signal toggle_map

func _ready():
	if not controls:
		printerr("Player controls have not been set!")
		set_physics_process(false)
	player_controls = controls
	
	load_player_equips()
	
	update_animation_parameters(Vector2(0, -1.1))
	

func load_player_equips(player_index = player_controls.player_index):
	var equips
	if player_index == 0:
		$Sprites.texture = load("res://assets/Robert/Robert_sprites.png")
		equips = DataController.get_data()["p1_equips"] as PlayerEquips
		if equips.hat:
			hat.texture = equips.hat["robert_texture"]
		else:
			hat.texture = null
		
		if equips.clothes:
			clothes.texture = equips.clothes["robert_texture"]
		else:
			clothes.texture = null
	else:
		$Sprites.texture = load("res://assets/Minnie/Minnie_sprites.png")
		equips = DataController.get_data()["p2_equips"] as PlayerEquips
		if equips.hat:
			hat.texture = equips.hat["minnie_texture"]
		else:
			hat.texture = null
		if equips.clothes:
			clothes.texture = equips.clothes["minnie_texture"]
		else:
			clothes.texture = null

var tick_count = 0

func _physics_process(_delta):
	if GameController.paused:
#		velocity = Vector2.ZERO
#		pick_state()
		update_animation_parameters(velocity)
		return
	
	var input_direction = Vector2(
			Input.get_action_strength(player_controls.move_right) - Input.get_action_strength(player_controls.move_left),
			Input.get_action_strength(player_controls.move_down) - Input.get_action_strength(player_controls.move_up)
		)	
	velocity = input_direction * move_speed
	
	update_animation_parameters(input_direction)
	
	pick_state()
	
	move_and_slide(self.velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if not collision:
			continue
		var collider = collision.collider
		if collider is TileMap and collider.name == "Walls":
			GameController.analyze_collisions(collision.position.x, collision.position.y, 0, 0, player_controls.player_index)
	
	emit_signal("player_moved", position.x, position.y)
	
	tick_count +=1
	if tick_count > 20:
		tick_count = 0
		GameController.analyze_movement(self.position.x, self.position.y, player_controls.player_index)
		GameController.analyze_heatmap(self.position.x, self.position.y, player_controls.player_index)
		var room = [int(position.x) / (GameController.room_width * 16), int(position.y) / (GameController.room_height * 16)]
		if GameController.world_gen == "Chunked":
			get_node("%Game").generate_chunk(room)
		

func _input(event):
	if event.is_action_pressed(player_controls.toggle_run):
		if not running:
			move_speed *= 1.35
		else:
			move_speed /= 1.35
		
		running = not running
	elif event.is_action_pressed(player_controls.toggle_map):
		emit_signal("toggle_map")

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input)
		

func pick_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
