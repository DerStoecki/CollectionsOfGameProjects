extends Area2D
class_name PlayerDetectorArea

signal hit_player()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.getHealth().damage()
		self.hit_player.emit()
