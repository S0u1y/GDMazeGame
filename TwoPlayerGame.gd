extends Node

onready var player1 = $HBoxContainer/ViewportContainer/Viewport/Game/Player1
onready var player2 = $HBoxContainer/ViewportContainer/Viewport/Game/Player2

onready var player1_viewport = $HBoxContainer/ViewportContainer/Viewport
onready var player2_viewport =  $HBoxContainer/ViewportContainer2/Viewport

#set both players variables
func _ready():
	player2_viewport.world_2d = player1_viewport.world_2d
	player1.map = $HBoxContainer/ViewportContainer/Viewport/Game/MapGrid
	player2.map = $HBoxContainer/ViewportContainer2/Viewport/MapGrid
	
