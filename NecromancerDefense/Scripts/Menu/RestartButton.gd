extends DefaultMenuButton
class_name RestartButton

func _on_button_pressed():
	super._on_button_pressed()
	get_tree().reload_current_scene()
