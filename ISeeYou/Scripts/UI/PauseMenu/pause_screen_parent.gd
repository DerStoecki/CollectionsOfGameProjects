extends CanvasLayer
class_name PauseParent


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PauseGame"):
		self.visible = !visible
		get_tree().paused = self.visible
		
