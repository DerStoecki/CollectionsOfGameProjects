class_name CostNode extends Node

@export var resource : GameResource.MyResource = GameResource.MyResource.FISH
@export var cost : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	(parent as ResourceCost).setResourceCost(resource, 
	self.cost)
		
