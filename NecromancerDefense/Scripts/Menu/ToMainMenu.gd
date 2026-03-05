extends DefaultMenuButton

class_name ToMainMenu

var mainMenu: String = "res://Scenes/Menu/main_menu.tscn"

func _on_button_pressed():
	super._on_button_pressed()
	get_tree().change_scene_to_file(mainMenu)

func _unhandled_input(event):
	if event.is_action_pressed("back"):
		self.pressed.emit()
