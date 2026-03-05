extends DefaultMenuButton
class_name ExitMenuButton


func _on_button_pressed():
	get_tree().quit()

func _unhandled_input(event):
	if $PanelContainer.visible:
		return
	if event.is_action_pressed("back"):
		$PanelContainer.visible = true
		get_viewport().set_input_as_handled()
