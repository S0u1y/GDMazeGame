extends Node

onready var map1 = $HBoxContainer/ViewportContainer/Viewport/Game/MapGrid
onready var map2 = $HBoxContainer/ViewportContainer2/Viewport/MapGrid

onready var player1 = $HBoxContainer/ViewportContainer/Viewport/Game/Player1
onready var player2 = $HBoxContainer/ViewportContainer/Viewport/Game/Player2

onready var player1_viewport = $HBoxContainer/ViewportContainer/Viewport
onready var player2_viewport =  $HBoxContainer/ViewportContainer2/Viewport

#set both players variables
func _ready():
	player2_viewport.world_2d = player1_viewport.world_2d
	
