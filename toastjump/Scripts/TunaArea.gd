extends Collectible

class_name Tuna_Area


func _on_body_entered(body: Node2D) -> void:
	if !active:
		return
	if body is Player:
		body.stamina = 0
	super._on_body_entered(body)
