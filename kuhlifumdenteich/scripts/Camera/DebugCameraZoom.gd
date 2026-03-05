extends Label


var movementController : CameraMoveSubController

# Called when the node enters the scene tree for the first time.
func _ready():
	self.movementController = self.get_parent() as CameraMoveSubController




func _process(delta):
	var str = "false"
	if self.movementController.zoomIn:
		str = "In"
	elif self.movementController.zoomOut:
		str = "Out"
	self.text = str("zooming: ", str)
