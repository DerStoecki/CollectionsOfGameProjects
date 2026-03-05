extends Control
class_name Inventory_And_Loadout_Management

@export var manager: InventoryManager
@export var camera: Camera2D
var initialized: bool

## A Helper class in the UI, it has a reference to the inventory manager and camera
## It has a Loadout and an Inventory. Those look at the true ReosurceManager and InventoryManager
## To check what is available/What to get/set etc.
##
##
##

func _process(_delta):
	if self.manager == null:
		return
	self.manager.connect("inventory_manager_start_game", Callable(self, "_on_inventory_manager_start_game"))
	_init_children_by_method("_my_init", self.manager, self.camera)
	_init_children_by_method("connect_signals")
	_init_children_by_method("setup_gui")
	self.set_process(false)

func _init_children_by_method(methodName: String, argument = null, arg2 = null):
	for child in get_children():
		if child.has_method(methodName):
			var cal = Callable(child, methodName)
			if argument != null:
				cal.call(argument, arg2)
			else:
				cal.call()
				

func _notify_loadout_empty(id: int): 
	print("notify Inventory_GUI")
	for child in get_children():
		if child is Inventory_GUI:
			child.unhide(id)

## Called when the GameManager receives a Signal -> Start Game
func _on_inventory_manager_start_game():
	for child in get_children():
		if child is Inventory_GUI:
			child.hide()
		elif child is LoadOutGui:
			for container in child._get_container():
				container._set_game_start()
