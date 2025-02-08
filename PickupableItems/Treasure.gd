extends Area2D

const _player_class = preload("res://Game/Player1.gd")

func _on_Treasure_body_entered(body):
	if body is _player_class:
		DataController._save.get_data().coins += 20
		GameController.game_state = "Ended"
		$"%PauseMenu".show_end_menu()
	
