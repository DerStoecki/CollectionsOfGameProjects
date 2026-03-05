class_name GameResource extends Node

enum MyResource {WOOD, IRON, WATER, FISH}

static func get_key_from_MyResource_value(value: int) -> String:
	for key in MyResource.keys():
		if MyResource[key] == value:
			return key
	return ""  # Value not found
