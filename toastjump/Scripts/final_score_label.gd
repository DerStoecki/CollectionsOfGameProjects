extends Label
class_name FinalScoreLabel

@export var isPlayerScoreName = false
@export var active : bool = false
var waitForRelease : bool = false
var curLetterIndex : int = 0
var savedKeyCode



signal userInputReady(name: String)

func _ready():
	get_viewport().focus_exited.connect(_on_window_focus_out)

func _input(event):
	if !active:
		return
	if !self.isPlayerScoreName:
		return
	if event is InputEventKey :
		var tempCode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		if savedKeyCode == tempCode and event.is_released():
			self.waitForRelease = false
			return
		if waitForRelease:
			return
		self.savedKeyCode = tempCode
		var inputKey : String = OS.get_keycode_string(self.savedKeyCode)
		if self.savedKeyCode == KEY_BACKSPACE and curLetterIndex > 0:
			self.text = self.text.erase(curLetterIndex - 1, 1)
			self.curLetterIndex -= 1
			self.waitForRelease = true
		if self.savedKeyCode == KEY_ENTER:
			self.userInputReady.emit(self.text)
			self.active = false
		if inputKey.length() == 1 and self.curLetterIndex < 3:
			self.waitForRelease = true
			self.text+=inputKey
			self.curLetterIndex += 1
	pass # Replace with function body.

func _on_window_focus_out():
	self.waitForRelease = false
