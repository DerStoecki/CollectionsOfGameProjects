extends DefaultMenuButton
class_name Exit_Yes

@export var parent: PanelContainer

func _ready():
	super._ready()
	grab_focus()

func _on_button_pressed():
	get_tree().quit()

func _unhandled_input(event):
	if not parent.visible:
		return
	if event.is_action_pressed("back"):
		pressed.emit()
