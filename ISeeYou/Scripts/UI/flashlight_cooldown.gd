extends TextureProgressBar
class_name FlashlightCooldown

@onready var parent: FlashLightUI = $".."

var flashlight : Enabler

var initialized : bool = false

func _ready():
	init()
		
		
func _process(_delta: float) -> void:
	if not initialized:
		self.init()
		return
	self.set_value(calculateValue())

func init():
	if parent and parent.flashlight:
		self.flashlight = parent.flashlight
		self.initialized = true
		
func calculateValue() -> float:
	# flashlight current_cooldown, base_cooldown 100%-current_cooldown
	var cd = flashlight.cur_cooldown_time
	var base = flashlight.base_cooldown
	if cd >= base:
		return 0
	return 100 - (cd*100/base)
