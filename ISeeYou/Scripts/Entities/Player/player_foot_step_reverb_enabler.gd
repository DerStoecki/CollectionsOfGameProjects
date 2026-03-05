extends Node
class_name FootStepEffectEnabler


@export var enabled : bool
@export var effectIndex : int
var bus_name : String  = "FootStepsMixer"
var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	self._setEffect(self.enabled)

func enableEffect():
	self._setEffect(true)
	
func disableEffect():
	self._setEffect(false)
	
func _setEffect(enable: bool):
	AudioServer.set_bus_effect_enabled(bus_index, self.effectIndex, enable)
	pass
