extends Control

class_name GameLostHandler

@export var loose : LooseArea

func _process(_delta):
	if loose.lost :
		self.visible = true
	self.set_process(false)
