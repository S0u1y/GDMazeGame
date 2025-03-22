extends Area2D

const _player_class = preload("res://Game/Player1.gd")

var coins_gain = 20

func _on_Treasure_body_entered(body):
	if body is _player_class:
		DataController._save.get_data().coins += coins_gain
		GameController.coins += coins_gain
		GameController.game_state = "Ended"
		$"%PauseMenu".show_end_menu()
	
