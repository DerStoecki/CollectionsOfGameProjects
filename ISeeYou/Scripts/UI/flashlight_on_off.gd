extends TextureRect
class_name FlashLightOnOff

@export var listen: ListenTo = ListenTo.ON
@onready var parent: FlashLightUI = $".."

var initialized: bool = false

enum ListenTo{ON, OFF}

func _ready() -> void:
	init()

func init():
	if self.parent and self.parent.flashlight:
		var fl = self.parent.flashlight as Enabler
		fl.activated.connect(_on_activated)
		fl.deactivated.connect(_on_deactivated)
		self.initialized = false
		
		self.set_process(false)
		
func _process(_delta: float) -> void:
	if not initialized:
		self.init()

func _on_activated():
	if self.listen == ListenTo.ON:
		self.visible = true
	else: 
		self.visible = false
func _on_deactivated():
	if self.listen == ListenTo.OFF:
		self.visible = true
	else:
		self.visible = false
	pass
