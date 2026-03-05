extends TextureRect
class_name OutOfOrderUI

@onready var parent : FlashLightUI = $".."
var initialized : bool = false

func _ready():
	init()
		
		
func _process(_delta: float) -> void:
	if not initialized:
		self.init()

func init():
	if parent and parent.flashlight:
		parent.flashlight.allow_handling_changed.connect(_on_allow_handling_changed)
		self.visible = not parent.flashlight.allow_handling
		self.initialized = true
		self.set_process(false)
		
func _on_allow_handling_changed(allowed: bool):
	self.visible = not allowed
	
