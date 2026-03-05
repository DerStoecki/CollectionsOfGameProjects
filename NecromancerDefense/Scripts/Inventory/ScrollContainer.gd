extends ScrollContainer
class_name InventoryScroll

func _my_init(manager: InventoryManager, cam : Camera2D):
	for child in self.get_children():
		if child is Inventory_GUI:
			child._my_init(manager, cam)
			child.connect_signals()
			child.setup_gui()
