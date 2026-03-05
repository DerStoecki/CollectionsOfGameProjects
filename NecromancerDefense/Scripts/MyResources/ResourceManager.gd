extends Node
class_name ResourceManager

@export var resourceMap = {}
@export var cheated_resources: bool = false

func _ready():
	for res in PawnResource.Res:
		self.resourceMap[res] = 0

func has_enough_resource_of_type(type: PawnResource.Res, amount: int) -> bool:
	if self.cheated_resources:
		return true
	if !self.resourceMap.has(type):
		return false
	return self.resourceMap[type] >= amount
	
func add_resource(type: PawnResource.Res, amount: int ):
	if !self.resourceMap.has(type):
		self.resourceMap[type] = 0
	var newAmount = self.resourceMap[type] + amount
	self.resourceMap[type] = max(newAmount, 0)

func subtract_resource(type: PawnResource.Res, amount: int):
	if self.cheated_resources:
		return
	if amount > 0:
		amount = amount * -1
	self.add_resource(type, amount)

func get_resourceAmount(type: PawnResource.Res) -> int :
	if not self.resourceMap.has(type):
		return 0
	return self.resourceMap[type]
	
