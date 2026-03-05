extends GridManager

class_name DummyGridManager

var manager: InventoryManager

## This is used for TestScenes

func _ready():
	self.manager = $InventoryManager
