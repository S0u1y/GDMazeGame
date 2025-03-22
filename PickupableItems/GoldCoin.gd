extends Area2D

const _player_class = preload("res://Game/Player1.gd")
func _on_Area2D_body_entered(body):
	if body is _player_class:
		DataController._save.get_data().coins += 1
#		Game coins are used to add to player score.
		GameController.coins += 1
		self.queue_free()
