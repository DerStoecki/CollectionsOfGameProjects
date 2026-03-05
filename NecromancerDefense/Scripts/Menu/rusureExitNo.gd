extends DefaultMenuButton
class_name Exit_No

@export var parent: PanelContainer

func _ready():
	super._ready()
	self.grab_focus()

func _on_button_pressed():
	parent.visible = false
	
