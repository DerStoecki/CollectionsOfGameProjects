extends HBoxContainer
class_name LoadOutGui

## The Loadout GUI is basically holding all pawns that are set up in the loadout/inventory phase
## When the game starts you can place pawns from this
## Connect all Signals to the inventoryManager
##
##

var inventoryManager: InventoryManager
var bpContainer: BlueprintContainer
var camera : Camera2D

func _my_init(manager: InventoryManager, cam : Camera2D):
	self.inventoryManager = manager
	self.camera = cam

func connect_signals():
	var managerIsNotNull = self.inventoryManager != null
	var loadoutNotConnected = managerIsNotNull and !inventoryManager.is_connected("slotUnlocked", Callable(self, "_on_inventory_manager_slot_unlocked"))
	var slotNotConnected = managerIsNotNull and !inventoryManager.is_connected("slotUnlocked", Callable(self, "_on_inventory_manager_slot_unlocked"))
	if loadoutNotConnected:
		inventoryManager.connect("init_loadout", Callable(self, "_on_inventory_manager_init_loadout"))
	if slotNotConnected:
		inventoryManager.connect("slotUnlocked", Callable(self, "_on_inventory_manager_slot_unlocked"))

func setup_gui():
	if inventoryManager.loadout == null:
		return
	var slot_to_bp_id = self.inventoryManager.get_loadout().get_load_slot_to_bp_id()
	var current_slots = self.inventoryManager.get_loadout().current_blueprint_slots
	for slot: int in current_slots:
		var bp_container = self._initEmptyBpContainer()
		if slot_to_bp_id.has(slot):
			bp_container._set_loadout(true)
			bp_container._hide(false)
			bp_container.set_blueprint(self.inventoryManager.get_blueprint_by_id(slot_to_bp_id[slot]))
	return
	
func _initEmptyBpContainer() -> BlueprintContainer:
	var bp_container = preload("res://Scenes/UI/Inventory/BlueprintContainer.tscn").instantiate() as BlueprintContainer
	bp_container._my_init(self.camera, self.inventoryManager.gridManager)
	bp_container._set_slotType(1)
	bp_container._empty_the_slot()
	self.add_child(bp_container)
	return bp_container

func _on_inventory_manager_init_loadout():
	self.setup_gui()

func _on_inventory_manager_slot_unlocked():
	self._initEmptyBpContainer()
	
## Notified by the Blueprint container -> if the loadout gets emptied in the loadoutphase -> empty this!
func _notify_loadout_empty(id: int):
	if get_parent() != null and get_parent().has_method("_notify_loadout_empty"):
		get_parent()._notify_loadout_empty(id)
		
func _get_container() -> Array[BlueprintContainer]:
	var baseChildren =  get_children().filter(Callable(self, "isContainer"))
	var new_bpContainer : Array[BlueprintContainer] = []
	for child : BlueprintContainer in baseChildren:
		new_bpContainer.append(child)
	return new_bpContainer
	
func isContainer(child):
	return child is BlueprintContainer
