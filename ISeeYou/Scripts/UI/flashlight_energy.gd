extends TextureProgressBar
class_name FlashLightEnergy

@onready var parent : FlashLightUI = $".."

var initialized: bool = false

func _ready() -> void:
	init()

func init():
	if self.parent and self.parent.energy:
		self.parent.energy.staminaChange.connect(set_value)
		self.set_process(false)
		
func _process(_delta: float) -> void:
	if not initialized:
		self.init()
