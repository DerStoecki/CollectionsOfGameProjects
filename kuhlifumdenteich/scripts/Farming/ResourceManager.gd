class_name ResourceManager extends Node3D

# has all resource Platforms, when new one is created or removed check them, when new resource
# -> signal to storage

var resourceCreator : Array[ResourceCreator] = []

var callable = Callable(self, "_resource_creator_done")

signal harvest_update(node: ResourceCreator)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Calling ready on ResourceManager")
	for child in self.get_children(false):
		print("childIteration")
		print(str(child.name, child.get_groups()))
		if child.is_in_group("ResourceCreator"):
			print("resourceCreatorFound")
			self.resourceCreator.append(child as ResourceCreator)
			child.connect("harvest_time", callable)
			


func _resource_creator_done(node: ResourceCreator):
	emit_signal("harvest_update", node)

func add_resource_creator(node: ResourceCreator):
	print("adding ResourceCreator")
	if !self.resourceCreator.has(node):
		self.resourceCreator.append(node)
		node.connect("harvest_time", callable)
	else: 
		print("whoops already here")
		
func only_connect(node: ResourceCreator):
	node.connect("harvest_time", callable)
		
