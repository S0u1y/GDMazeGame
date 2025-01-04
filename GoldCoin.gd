extends Area2D

const _player_class = preload("res://Player1.gd")
func _on_Area2D_body_entered(body):
	if body is _player_class:
		body.coins += 1
		self.queue_free()
