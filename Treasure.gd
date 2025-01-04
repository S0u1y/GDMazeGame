extends Area2D

const _player_class = preload("res://Player1.gd")

func _on_Coin_body_entered(body):
	if body is _player_class:
		GameController.game_state = "Ended"
		print(GameController.game_state)

