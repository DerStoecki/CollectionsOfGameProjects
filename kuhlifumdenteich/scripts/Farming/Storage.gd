class_name ResourceStorage extends Node3D

var storagedGoods = {}
@export var resourceManagerPath : NodePath

var resourceManager : ResourceManager

signal storage_update(node: ResourceStorage) 

# Called when the node enters the scene tree for the first time.
func _ready():
	for resource in GameResource.MyResource.keys():
		#print(resource)
		storagedGoods[resource] = 0
	self.resourceManager = self.get_node(resourceManagerPath) as ResourceManager
	var callable = Callable(self, "handle_harvest")
	self.resourceManager.connect("harvest_update", callable)
	
	

func handle_harvest(node: ResourceCreator):
	var resourceType = GameResource.MyResource.keys()[node.RESOURCE_TYPE]
	var currentCount : float = 0
	if self.storagedGoods.has(resourceType):
		currentCount = self.storagedGoods[resourceType]
	currentCount += node.value_on_timeout
	self.storagedGoods[resourceType] = currentCount
	emit_signal("storage_update", self)
	#print("Current Storage: ")
	#print(str(self.storagedGoods))
