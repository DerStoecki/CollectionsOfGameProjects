class_name UIStorage extends HBoxContainer

@export var storagePath : NodePath

var storage : ResourceStorage

var wood : Label
var fish : Label
var iron : Label
var water : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	self.wood = get_node("WOOD")
	self.fish = get_node("FISH")
	self.iron = get_node("IRON")
	self.water = get_node("WATER")
	if self.storagePath != null:
		self.storage = get_node(self.storagePath) as ResourceStorage
		var callable = Callable(self, "_update_ui")
		self.storage.connect("storage_update", callable)
		self._update_ui(self.storage)


func _update_ui(givenStorage: ResourceStorage):
	for resource in GameResource.MyResource :
		var label = get_node(str(resource)) as Label
		label.text = str(resource, ": ", givenStorage.storagedGoods[resource])
	
