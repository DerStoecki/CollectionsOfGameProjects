extends BasicInteractUIButton
class_name ContinueButton

@onready var pauseScreen:PauseParent = $"../../.."

func _on_pressed() -> void:
	pauseScreen.get_tree().paused = false
	pauseScreen.visible = false
	

func _on_pause_screen_visibility_changed() -> void:
	if pauseScreen.visible:
		self.grab_focus()
