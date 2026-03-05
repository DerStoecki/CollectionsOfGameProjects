extends AnimatedSprite2D
class_name InteractIconChanger

var lastInputWasController : bool = false

func _ready():
	self.play("Controller_Interact")
	

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		self.lastInputWasController = true
	elif event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		self.lastInputWasController = false

func _on_animation_finished() -> void:
	if lastInputWasController:
		self.play("Controller_Interact")
	else:
		self.play("Keyboard_Interact")
