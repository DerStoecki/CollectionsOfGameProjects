extends Button
class_name DefaultMenuButton

@export var unpauseOnClick: bool

func _ready():
	self.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	self.connect("pressed", Callable(self, "_on_button_pressed"))

func _on_mouse_entered():
	grab_focus()

func _on_button_pressed():
	if unpauseOnClick:
		get_tree().paused = false
