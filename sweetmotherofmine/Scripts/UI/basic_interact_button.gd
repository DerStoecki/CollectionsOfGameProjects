extends Button
class_name BasicInteractUIButton


func _ready() -> void:
	if not self.mouse_entered.is_connected(_on_mouse_entered):
		self.mouse_entered.connect(_on_mouse_entered)
	

func _input(event: InputEvent) -> void:
	if self.has_focus() and (event.is_action_pressed("Interact") or event.is_action_pressed("Jump")):
		self.pressed.emit()
		if get_viewport():
			get_viewport().set_input_as_handled()

func _on_mouse_entered():
	self.grab_focus()
