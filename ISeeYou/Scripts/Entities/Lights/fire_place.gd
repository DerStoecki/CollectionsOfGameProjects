extends AnimatedSprite2D
class_name Fireplace


func _on_interact_area_interacted() -> void:
	self.play("Fire")
	self.visible = true
