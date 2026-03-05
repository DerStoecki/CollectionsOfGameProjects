extends EnabledDisabled
class_name FlashlightEnableDisable

@onready var flashArea: Area2D = $".."

func enable():
	if self.flashArea:
		self.flashArea.monitorable = true
		self.flashArea.set_collision_layer_value(5, true)
	
func disable():
	if self.flashArea:
		self.flashArea.monitorable = false
		self.flashArea.set_collision_layer_value(5, false)
