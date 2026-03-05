extends TextureButton
class_name BaseStageOrWorldTextureButton

signal enter_highlight
signal exit_highlight

@export var parent : BaseStageOrWorldContainer

func _ready():
	if not self.mouse_entered.is_connected(Callable(self, "_on_mouse_entered")):
		self.mouse_entered.connect(Callable(self, "_on_mouse_entered"))
		self.mouse_exited.connect(Callable(self, "_on_mouse_exited"))
		self.focus_entered.connect(Callable(self, "_on_focus_entered"))
		self.focus_exited.connect(Callable(self, "_on_focus_exited"))
		self.pressed.connect(Callable(self, "_on_pressed"))

func _on_mouse_entered():
	enter_highlight.emit()
	grab_focus()
	
func _on_mouse_exited():
	exit_highlight.emit()

func _on_focus_entered():
	enter_highlight.emit()	
	
func _on_focus_exited():
	exit_highlight.emit()

func _on_pressed():
	self.parent.loadNextScene()
	
