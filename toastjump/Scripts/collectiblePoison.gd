extends Collectible
class_name Poison

var collected: bool = false

signal gameOver()

func _on_body_entered(body: Node2D) -> void:
	if !active:
		return
	if body is Player and !self.collected :
		self.play_collect = false
		self.collected = true
		gameOver.emit()
		super._on_body_entered(body)
 
