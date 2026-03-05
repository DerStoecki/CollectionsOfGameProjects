extends Control
class_name UI_Parent

@onready var animSM : PlayerAnimationHandler = $"../../AnimationTreePlayer"
@onready var startBtn: Button = $StartGame

func startNewGame():
	self.set_children_visible(false)

func set_children_visible(val: bool):
	for child in get_children():
		child.visible = val

func hide_children():
	set_children_visible(false)
	
func show_children():
	set_children_visible(true)

func disable_children():
	set_disable_children(true)
		
func enable_children():
	set_disable_children(false)
	
func set_disable_children(val: bool):
	for child in get_children():
		if child is Button:
			child.disabled = val
func _input(event: InputEvent) -> void:
	if animSM.is_opened_menu() and event is InputEventJoypadMotion or event is InputEventJoypadButton:
		for child in get_children():
			if child is Button:
				if child.has_focus() or not child.visible: # not visible -> is in either how to play or settings
					return
		startBtn.grab_focus()
		
