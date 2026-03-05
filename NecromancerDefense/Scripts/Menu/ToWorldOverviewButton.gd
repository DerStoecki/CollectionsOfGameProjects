extends DefaultMenuButton

class_name ToWorldOverviewButton

@export var pathToScene: String

func _ready():
	super._ready()


func _on_button_pressed():
	get_tree().change_scene_to_file(pathToScene)

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("back"):
		self.pressed.emit()

func _unhandled_input(event):
	if event.is_action_pressed("back"):
		self.pressed.emit()
