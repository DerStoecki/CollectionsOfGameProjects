extends Label

var movementController : CameraMoveSubController

# Called when the node enters the scene tree for the first time.
func _ready():
	self.movementController = self.get_parent() as CameraMoveSubController




func _process(delta):
	self.text = str("tilting:", self.movementController.tilt)
