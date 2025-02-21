extends Control

onready var purchase_container = $"%PurchaseContainer"
onready var cost_label = $"%Cost"

onready var owned_container = $"%OwnedContainer"
onready var equipped_btn = $"%Equipped"

onready var coins_amount_label = $Panel/CoinsAmountContainer/HBoxContainer/Label

var player_data = DataController._save.get_data()
var cosmetics: Dictionary = player_data.cosmetics

var selected_player = 0
var selected_item = null
var last_cosmetic = null
var selected_cosmetic = null
var selected_type = null

func _ready():
	GameController.paused = true
	$Panel/Player1.velocity = Vector2(0, 1.1)
	
	coins_amount_label.text = str(player_data.coins)
	
	for cosmetic in cosmetics:
		var new_button = Button.new()
		new_button.name = cosmetic
		new_button.text = cosmetic
		$"%CosmeticsList".add_child(new_button)
		new_button.connect("pressed", self, "_on_cosmetics_picked", [new_button.text])
	
	$Panel/PlayerSelection/Player1.group.connect("pressed", self, "_on_player_changed")
	

func _on_cosmetics_picked(cosmetic_name:String):
	if cosmetic_name == selected_item:
		return
	if $"%NotEnoughMoney".visible:
		$"%NotEnoughMoney".visible = false
	
	selected_item = cosmetic_name
	last_cosmetic = selected_cosmetic
	selected_cosmetic = cosmetics[cosmetic_name]
	selected_type = selected_cosmetic.type as String
	
	$Panel/CosmeticInfoContainer.visible = true
	
	if selected_cosmetic.owned:
		purchase_container.visible = false
		owned_container.visible = true
		owned_container.get_node("Equipped").pressed = player_data["p"+String(selected_player+1)+"_equips"][selected_cosmetic.type] == selected_cosmetic
		
	else:
		purchase_container.visible = true
		owned_container.visible = false
		
		cost_label.text = cosmetic_name + ": " + String(selected_cosmetic.cost)
	
	$Panel/Player1[selected_type].texture = selected_cosmetic[lower_first_letter(player_data.get_property_by_player_idx(selected_player+1, "character"))+"_texture"]
	

func _exit_tree():
	GameController.paused = false

func _on_Back_pressed():
	get_tree().change_scene_to(SceneSwapper.get_scene("Main Menu"))

func _on_PurchaseBtn_pressed():
	if not selected_cosmetic:
		return
	
	if player_data.coins >= selected_cosmetic.cost:
		player_data.coins -= selected_cosmetic.cost
		coins_amount_label.text = str(player_data.coins)
		selected_cosmetic.owned = true
		purchase_container.visible = false
		owned_container.visible = true
		owned_container.get_node("Equipped").pressed = player_data.get_property_by_player_idx(selected_player+1, "equips")[selected_cosmetic.type] == selected_cosmetic
	else:
		purchase_container.visible = false
		$"%NotEnoughMoney".visible = true
		
		yield(get_tree().create_timer(3), "timeout")
		
		if owned_container.visible or not $"%NotEnoughMoney".visible:
			return
		
		purchase_container.visible = true
		$"%NotEnoughMoney".visible = false


func _on_Equipped_pressed():
	player_data.get_property_by_player_idx(selected_player+1, "equips")[selected_type] = selected_cosmetic

func _on_player_changed(button):
	if button.name == "Player2":
		selected_player=1
		$Panel/Player1/Sprites.texture = load("res://assets/Minnie/Minnie_sprites.png")
	else:
		selected_player=0
		$Panel/Player1/Sprites.texture = load("res://assets/Robert/Robert_sprites.png")
	
	$Panel/Player1.load_player_equips(selected_player)
	
	selected_type = null
	last_cosmetic = null
	selected_item = null
	selected_cosmetic = null
	$Panel/CosmeticInfoContainer.visible = false
	purchase_container.visible = false
	owned_container.visible = false

func capitalize_first_letter(string:String):
	return string[0].to_upper() + string.substr(1,-1)

func lower_first_letter(string:String):
	return string[0].to_lower() + string.substr(1,-1)
