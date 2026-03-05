class_name ResourceCost extends Node3D

var _resourceCost : Dictionary = {}
var resourceCost : Dictionary: 
	get:
		return _resourceCost		


func setResourceCost(key: GameResource.MyResource, value: int) :
	var res = GameResource.MyResource.keys()[key]
	print(str(res, value))
	self.resourceCost[res] = value
